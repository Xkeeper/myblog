require 'spec_helper'

describe String, '#slugorize' do
	it "should lowercase everything" do
		"ABCDEF".slugorize.should == "abcdef"
	end

	it "should leave alphanumerics and hyphens alone" do
		"abc-123".slugorize.should == "abc-123"
	end

	it "should ditch entities" do
		"abc&;-&#;xyz".slugorize.should == "abc-xyz"
	end

	it "should remove &" do
		"a-&-b-&-c".slugorize.should == "a-b-c"
	end

	it "should strip all non-alphanumeric characters except - and &" do
		'abc""!@#$%^*()/=+|\[],.<>123'.slugorize.should == "abc-123"
	end

	it "should replace all whitespace with a dash" do
		"abc\n\t     xyz".slugorize.should == "abc-xyz"
	end

	it "should trim dashes at the tail" do
		"abc--".slugorize.should == "abc"
	end

	it "should trim dashes at the head" do
		"--abc".slugorize.should == "abc"
	end

	it "should collapse multiple dashes" do
		"abc---xyz".slugorize.should == "abc-xyz"
	end
end

