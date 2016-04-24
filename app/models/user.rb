class User < ActiveRecord::Base
  # has_secure_password does the following:
  # 1 - it adds attribute accessors: password and password_confirmation
  # 2 - It adds validation: password must be present on creation
  # 3 - If password confirmation is present, it will make sure it's equal to password
  # 4 - Password length should be less than or equal to 72 characters
  # 5 - It will has the password using BCrypt and stores the hash
  # digest in the password_digest field
  has_secure_password


  has_many :posts, dependent: :nullify
  has_many :comments, dependent: :nullify

  validates :first_name, presence: true
  validates :last_name, presence: true
  #VALID_EMAIL_REGEX = /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  #validates :email, uniqueness: VALID_EMAIL_REGEX, presence: true

  VALID_EMAIL_REGEX = /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, uniqueness: true, presence: true, format: VALID_EMAIL_REGEX


  def full_name
    "#{first_name} #{last_name}"
  end

  def generate_password_reset_data
    # what should the token be, can you generate a random token
    # it has to be unique
    # better to not use hash digest in this case, in case the user
    # tries to play with that and tries to figure our algorithm
    # use SecureRandom
    # 32 characters of hex
    # how do I make sure it is unique
    # don't want to put the user id in it
    generate_password_reset_token
    # when you don't do self, it will just define a local variable instead
    # we are using the attribute accessor built in with rails
    self.password_reset_requested_at = Time.now
    # save the record in the database
    save
  end

  def generate_account_verification_data
    # we will use the same password_reset_token field for the initial account
    # verification
    generate_password_reset_token
    # when you don't do self, it will just define a local variable instead
    # we are using the attribute accessor built in with rails
    self.activation_requested_at = Time.now
    # save the record in the database
    save
  end

  def generate_password_reset_token
    # begin/while runs at least once
    begin
      self.password_reset_token = SecureRandom.hex(32)
      # check if something exist in ActiveRecord
    end while User.exists?(password_reset_token: self.password_reset_token)
  end

  def password_reset_expired?
    # returns true if password expired
    # if the requested date is less than 60 minutes go, then it has expired,
    # returns true
    password_reset_requested_at < 60.minutes.ago
  end

end
