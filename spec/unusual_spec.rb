

describe "something unusual" do
	before :each do 
		## values for something_unusual ##
		values = [45, 55, 66, 88, 99]
		@temp=[]
 		values.each {|val| @temp << val }
 	end

 	## first condition ##
	it "accepts an array of numbers" do
		@temp.should eql [45, 55, 66, 88, 99]
	end

	## second condition ##
	it "returns an array of correct values" do
		@temp.class.should eql Array
	end

	## third condition ##
	it "has 5 stored temps" do
		@temp.count.should eql 5
	end

end