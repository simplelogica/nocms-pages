class TestImage < ActiveRecord::Base
  mount_uploader :logo, LogoUploader
end
