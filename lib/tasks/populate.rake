namespace :fill do
  desc 'Fill data'
  task data: :environment do
    require 'faker'
    require 'populator'
    puts 'Erasing existing data'
    puts '====================='

    [User, Post, Event, Comment].each(&:delete_all)
    ActsAsVotable::Vote.delete_all
    PublicActivity::Activity.delete_all

    puts 'Creating users'
    puts '=============='
    genders = ['male', 'female']
    password = 'password'

    User.populate 100 do |user|
      user.name = Faker::Name.name
      user.email = Faker::Internet.email
      user.sex = genders
      user.dob = ("01/01/" + rand(1970..2000).to_s).to_date
      user.phone_number = Faker::PhoneNumber.cell_phone
      user.encrypted_password = User.new(password: password).encrypted_password
      user.confirmed_at = DateTime.now
      user.sign_in_count = 0
      user.posts_count = 0
      user.location =  %w(Kyiv Kharkiv Odessa Dnipro Donetsk Zaporizhia Lviv Mykolaiv Mariupol Luhansk Vinnytsia Kherson Poltava Chernihiv).sample
      puts "created user #{user.name}"
    end

    user = User.new(name: 'Mykyta Didenko', email: 'ndidenko@matcha.com', sex: 'male', password: 'password')
    # user.skip_confirmation!
    user.dob = ("01/01/" + rand(1970..2000).to_s).to_date
    user.phone_number = Faker::PhoneNumber.cell_phone
    user.latitude = 50.4500336
    user.longitude = 30.5241361
    user.save!
    puts 'Created test user with email=ndidenko@matcha.com and password=password'

    for i in 1..5
      user = User.new(name: "test#{i}", email: "test#{i}@matcha.com", sex: 'male', password: 'password')
      # user.skip_confirmation!
      user.dob = ("01/01/" + rand(1970..2000).to_s).to_date
      user.phone_number = Faker::PhoneNumber.cell_phone
      user.latitude = rand(50.0...50.9)
      user.longitude = rand(30.0...30.9)
      user.save!
      puts "Created test user with email=test#{i}@matcha.com and password=password"
    end

    puts 'Generate Friendly id slug for users'
    puts '==================================='
    User.find_each(&:save)

    puts 'Creating Posts'
    puts '=============='
    users = User.all

    150.times do
      post = Post.new
      post.content = Populator.sentences(2..4)
      post.user = users.sample
      post.save!
      puts "created post #{post.id}"
    end

    puts 'Creating Comments For Posts'
    puts '==========================='

    posts = Post.all

    150.times do
      post = posts.sample
      user = users.sample
      comment = post.comments.new
      comment.comment = Populator.sentences(1)
      comment.user = user
      comment.save
      puts "user #{user.name} commented on post #{post.id}"
    end

    puts 'Creating Events'
    puts '==============='

    15.times do
      event = Event.new
      event.name = Populator.words(1..3).titleize
      event.event_datetime = Faker::Date.between(2.years.ago, 1.day.from_now)
      event.user = users.sample
      event.save
      puts "created event #{event.name}"
    end

    puts 'Creating Likes For Posts'
    puts '========================'

    750.times do
      post = posts.sample
      user = users.sample
      post.liked_by user
      puts "post #{post.id} liked by user #{user.name}"
    end

    puts 'Creating Likes For Events'
    puts '========================='
    events = Event.all

    150.times do
      event = events.sample
      user = users.sample
      event.liked_by user
      puts "event #{event.id} liked by user #{user.name}"
    end

    puts 'Creating Comments For Events'
    puts '============================='

    300.times do
      event = events.sample
      user = users.sample
      comment = event.comments.new
      comment.commentable_type = 'Event'
      comment.comment = Populator.sentences(1)
      comment.user = user
      comment.save
      puts "user #{user.name} commented on event #{event.id}"
    end

  end
end
