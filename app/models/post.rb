class Post < ApplicationRecord
    mount_uploader :image, ImageUploader
    
    belongs_to :user
    
    validates :image, presence: true
    validates :content, presence: true
    validates :user_id, presence: true
    
    has_many :likes
    has_many :like_users, through: :likes, source: :user
    
    def toggle_like(user)
      if self.like_users.include?(user)
        self.like_users.delete(user)
      else
        self.like_users.push(user)
      end
    end
end
