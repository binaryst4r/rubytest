# Instructions for this test:
# 1. Please clone this gist as a git repo locally
# 2. Create your own github repo called 'rubytest' (or a name of your choice) and add this repo as a new remote to the cloned repo
# 3. Edit this file to answer the questions, and push this file with answers back out to your own 'rubytest' repo.

# Problem 1. Explain briefly what this code does. Create a RSpec unit test for
# it, fix any bugs, then clean up the syntax to be more idiomatic Ruby and make
# sure your tests still pass.
#
# Your spec should have at least 3 contexts/conditional tests (what are they?)
def something_unusual(values)
 temp = []
 values.each {|val| temp << val}
 return temp
end

############# Answer to Problem 1 ##########################
# This method takes an array and reassigns the values into a different array called temp
# Tests are written in the spec folder in the unusual_spec file.
#############################################################


# Problem 2. This is a piece of code found in a fictional Rails controller and model
# for simulating problems while driving a car.
#
# Point out any bugs or security problems in the code, fix them, and refactor the code to
# make it cleaner.
#
# Hint: this controller is way too intimate with the functionality of the car. What happens
# when we want to reuse the logic for simulating a wheel breakage somewhere else?
class CarSimulationController
 def break_random_wheel
   @car = Car.where("name = ? and user = ? ", "#{params[:name]}", "#{params[:user_id]}").first
   @car.break_random_wheel
 end
end

class Car < ActiveRecord::Base
 has_many :components

 def break_random_wheel
  wheels = self.components.find_by_type('wheel')
  wheels[rand*4].break!
  self.functioning_wheels -=1
   
 end

end

class User < ActiveRecord::Base
end

############## Answer to problem 2 #####################
# The first issue I came across was a SQL-injection attack risk on the first line of the method. This is fixed by
# replacing the conditions with a '?'. This way no one can see what SQL queries are being done on the server log. 

# Secondly, @car initially would return an active record relation, not an actual Car object so you must add .first
# to the end of the statement to be able to call any methods on the car.

# I then moved most of the logic into the model so the method could be used throughout the whole application
# wherever an instance of car is used. I also removed the random_wheel variable because it didn't accurately
# represent a random_wheel as much as it was just a randomizer that could be easily called with @wheels[rand*4].
# Also cleaned up @wheels using find_by_type. 
########################################################


# Problem 3. You are running a Rails application with 2 workers (two unicorn processes, two passenger workers, etc).
# You have code that looks like this

class CarsController
 def start_engine
  @car = Car.first # bonus: there is a bug here. what is it? Car.all.first
  @car.start_engine
 end
end

class Car
 def start_engine
  api_url = "http://my.cars.com/start_engine?id={self.id}"
  RestClient.post api_url
 end
end

# 3a. Explain what possible problems could arise when a user hits this code.
# 3b. Imagine now that we have changed the implementation:

class CarsController
 def start_engine
  sleep(30)
 end
 def drive_away
  sleep(10)
 end
 def status
  sleep(5)
  render :text => "All good!"
 end
end

# Continued...Now you are running your 2-worker app server in production.
#
# Let's say 5 users (call them x,y,z1,z2,z3), hit the following actions in
# order, one right after the other.
#
# x: goes to start_engine
# y: goes to drive_away
# z1: goes to status
# z2: goes to status
# z3: goes to status
#
# Explain approximately how long it will take for each user to get a response back from the server.
#
# Example: user 'x' will take about 30 seconds. What about y,z1,z2,z3?
#
# user 'x' will take about 30 seconds.
# user 'y' will take about 10 seconds.
# user 'z1' will take about 15 seconds.
# user 'z2' will take about 20 seconds.
# user 'z3' will take about 20 seconds.
#
# Approximately how many requests/second can your cluster process for the
# action 'start_engine'? What about 'drive_away'?  What could you do to
# increase the throughput (requests/second)?


# Problem 4. Here's a piece of code to feed my pets. Please clean it up as you see fit.

cat = Cat.new
dog = Dog.new
cow = Cow.new
my_pets = [cat, dog, cow]

my_pets.each {|pet| pet.feed}


class Pet
 
end

class Cat < Pet
  def feed
    puts "thanks"
  end
end

class Dog < Pet
  def feed
    puts "thanks"
  end
end

class Cow < Pet
  def feed
    puts "thanks"
  end
end

# Problem 5. Explain in a few sentences the difference between a ruby Class and
# Module and when it's appropriate to use either one.

################# Answer to problem 5 ###########################
# A ruby class contains methods that are primarly used for behavior of it's own instances. Whereas a module is
# more like a library of methods that can be used across different situations and contains no real instances of
# themselves. A class should be used when the application dictates the use of multiple instances with the same
# behaviors. A module would be more appropriate when you need methods throughout an entire app on multiple different objects.
#############################################################

# Problem 6. Explain the problem with this code

class UsersController
 def find_active_users
  User.find(:all).select {|user| user.active?}
 end
end

########### Answer to problem 6 ################
# There is no instance variable to use for the output.
# Should be something like @active_users = User.find(:all).select {|user| user.active?}
################################################


# Problem 7. Here's a piece of code that does several actions. You can see that it has duplicated
# error handling, logging, and timeout handling. Design a block helper method that will remove
# the duplication, and refactor the code to use the block helper.

logger.info "About to do action1"
Timeout::timeout(5) do
 begin
  action1
 rescue => e
  logger.error "Got error: #{e.message}"
 end
end

logger.info "About to do action2"
Timeout::timeout(10) do
 begin
  action2
 rescue => e
  logger.error "Got error: #{e.message}"
 end
end

logger.info "About to do action3"
Timeout::timeout(7) do
 begin
  action3
 rescue => e
  logger.error "Got error: #{e.message}"
 end
end
