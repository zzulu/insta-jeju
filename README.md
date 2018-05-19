# Insta Jeju

인스타 따라 만들기

## 180518

### 새 Rails Project 만들기

Terminal에서 아래와 같이 명령어를 입력하여 프로젝트를 생성하고, 폴더 안으로 이동한다.

```console
rails new insta-jeju
cd insta-jeju
```

### Scaffold로 기본 구조 만들기

Terminal에서 아래의 명령어를 입력하여 Post Scaffold를 생성한다.

```console
rails g scaffold Post image:text content:text
```

### IAM Key 만들기 (AWS 사이트)
1. 좌측 상단 '서비스' > '보안, 자격 증명 및 규정 준수' > 'IAM' 클릭
2. 왼쪽 사이드바에 '사용자' 클릭
3. 좌측 상단 **'사용자 추가'** 클릭
4. 생성하고자 하는 이름을 '사용자 이름'에 입력, '액세스 유형'을 **프로그래밍 방식 액세스**에 체크하고 **'다음'** 클릭
5. **'그룹 생성'** 클릭(S3 사용을 위해 이미 만들어 놓은 그룹이 있다면, 그것을 선택.)
6. '그룹 이름'을 입력, '검색' 칸에서 **S3**를 검색하여 나오는 결과중 **AmazonS3FullAccess**를 체크하고 **'그룹 생성'** 클릭
7. 생성된 그룹을 체크하고 **'다음'** 클릭
8. **'사용자 만들기'** 클릭
9. **'.csv 다운로드'** 버튼을 클릭하여 ID와 KEY를 저장하거나 **'비밀 액세스 키'** 아래쪽의 '보기'를 클릭하여 ID와 KEY를 확인. 여기서 확인할 수 있는 KEY는 이 페이지를 벗어나면 다시 확인이 불가능하므로 꼭 다운로드를 하거나 다른 곳에 복사해두어야 한다. 또한 타인에게 알려지면 안되는 중요한 정보이므로 인터넷 상에 업로드하는 일이 없도록 하여야한다.


### S3 Bucket 만들기 (AWS 사이트)
1. 좌측 상단 '서비스' > '스토리지' > 'S3' 클릭
2. 좌측 상단 **'버킷 만들기'** 클릭
3. '버킷 이름'을 지정, '리전'을 '아시아 태평양 (서울)'로 선택하고, '다음'를 계속 클릭하여 버킷을 생성


### Credentials 설정하기

Terminal에서 아래의 명령어를 입력하여, credentials.yml.enc 파일을 수정한다. 만약 master.key 파일이 config 폴더 안에 존재하지 않는다면, 기존의 credentials.yml.enc를 수정할 수 없으니 해당 credentials.yml.enc파일을 생성할 때 사용하였던 master.key를 구하거나, 구하지 못한다면 credentials.yml.enc를 새로 만들어야 한다.

```console
EDITOR="vi" rails credentials:edit
```

아래의 내용으로 수정한 후, `:wq` 또는 `ZZ`로 저장하고 vi를 종료한다.

```yml
aws:
  access_key_id: 다운로드 하였던 ID
  secret_access_key: 다운로드 하였던 KEY
```


### Gemfile 

```ruby
gem 'fog'
gem 'carrierwave'
```

위의 gem들을 **Gemfile**에 추가 후, 아래 쪽의 terminal에서 `bundle install` 명령어로 gem 설치.

오류가 발생하여 설치가 진행되지 않는다면, 아래의 명령어로 필요 라이브러리를 설치하자.

1. AWS C9 (Amazon Linux)

```console
sudo yum install libxml2-devel libcurl-devel
```

2. Old C9 (Ubuntu)

```console
sudo apt-get update && sudo apt-get install libxml2-dev libcurl4-openssl-dev
```

### config/initalizers/fog.rb

파일을 새로 생성한 후, 아래의 코드를 복사하여 붙여넣는다.

```ruby
CarrierWave.configure do |config|
  config.fog_credentials = {
    provider:              'AWS',
    aws_access_key_id:     Rails.application.credentials.dig(:aws, :access_key_id),
    aws_secret_access_key: Rails.application.credentials.dig(:aws, :secret_access_key),
    region:                'ap-northeast-2'
  }
  config.fog_directory  = '아까 생성한 S3 Bucket의 이름'
end
```

여기서 서버를 정지 하였다가 다시 실행하여 준다.

### Uploader 만들기

1. Terminal에 `rails g uploader image`를 입력하여 uploader 파일을 생성한다. `app/uploaders` 폴더에 `image_uploader.rb`파일이 생성된다.
2. `image_uploader.rb`파일에서 해당하는 부분의 코드를 다음과 같이 수정해준다.

```ruby
# Choose what kind of storage to use for this uploader:
# storage :file
storage :fog
```

### Uploader 마운트 하기

`app/models/post.rb` 파일을 다음과 같이 수정한다.

```ruby
class Post < ActiveRecord::Base
  mount_uploader :image, ImageUploader
end 
```

### View 수정하기


1. `app/views/posts/_form.html.erb`

`.text_area`를 `.file_field`로 수정.

```erb
<%= form.label :image %>
<%= form.file_field :image %>
```


2. app/views/posts/show.html.erb

`@post.image`를 `image_tag @post.image.url, width: '200px'`로 수정.

```erb
<strong>Image:</strong>
<%= image_tag @post.image.url, width: '200px' %>
```


3. app/views/posts/index.html.erb

`post.image`를 `image_tag post.image.url, width: '200px'`로 수정.

```erb
<td><%= image_tag post.image.url, width: '200px' %></td>
```