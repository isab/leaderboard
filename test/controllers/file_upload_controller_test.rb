require 'test_helper'

class FileUploadControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get file_upload_new_url
    assert_response :success
  end

end
