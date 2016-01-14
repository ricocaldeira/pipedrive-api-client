require 'helper'

class TestPipedriveAuthentication < Test::Unit::TestCase
  should "set authentication credentials on Pipedrive::Base" do
    Pipedrive.authenticate("some-token")
    assert_equal "some-token", Pipedrive::Base.default_options[:default_params][:api_token]
  end

  should "send authentication token with each request" do
    Pipedrive.authenticate("some-token")

    stub_request(:get, "https://api.pipedrive.com/v1/?api_token=some-token").
      with(:headers => {
        'Accept'=>'application/json',
        'Content-Type'=>'application/x-www-form-urlencoded',
        'User-Agent'=>'Ruby.Pipedrive.Api'
      }).
      to_return(:status => 200, :body => "", :headers => {})
    Pipedrive::Base.get("/")
  end

  should "update authentication credentials on Pipedrive::Base after a request" do
    stub_request(:get, "https://api.pipedrive.com/v1/users?api_token=344c5570b35c748c74f3927b3925a8787c3c95be").
      with(:headers => {
        'Accept'=>'application/json',
        'Content-Type'=>'application/x-www-form-urlencoded',
        'User-Agent'=>'Ruby.Pipedrive.Api'
      }).
      to_return(:status => 200, :body => "", :headers => {})

    stub_request(:get, "https://api.pipedrive.com/v1/users?api_token=my-new-token").
        with(:headers => {'Accept'=>'application/json', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Ruby.Pipedrive.Api'}).
        to_return(:status => 200, :body => "", :headers => {})

    Pipedrive.authenticate("344c5570b35c748c74f3927b3925a8787c3c95be")
    assert_equal "344c5570b35c748c74f3927b3925a8787c3c95be", Pipedrive::Base.default_options[:default_params][:api_token]
    assert_equal "344c5570b35c748c74f3927b3925a8787c3c95be", Pipedrive::User.default_options[:default_params][:api_token]
    Pipedrive::User.all
    Pipedrive.authenticate("my-new-token")
    Pipedrive::User.all
    assert_equal "my-new-token", Pipedrive::Base.default_options[:default_params][:api_token]
    assert_equal "my-new-token", Pipedrive::User.default_options[:default_params][:api_token]
  end
end
