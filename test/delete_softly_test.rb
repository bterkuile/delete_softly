require 'test_helper'

class DeleteSoftlyTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  setup do
    Post.delete_all
    Coment.delete_all
    @post1 = Post.create(:id =>1, :title => "post1")
  end
  test "the truth" do
    assert true
  end
  test "one record available" do
    assert_equal 1, Post.count
  end

  test "destroy count test" do
    @post1.destroy
    assert_equal 0, Post.count
    assert_equal 1, Post.with_deleted.count 
  end
end
