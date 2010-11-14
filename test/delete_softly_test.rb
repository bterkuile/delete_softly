require 'test_helper'

class DeleteSoftlyTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  setup do
    puts "New setup"
    Post.with_deleted.delete_all
    Comment.with_deleted.delete_all
    Tag.delete_all
    @post1 = Post.create(:title => "post1")
    @post1_id = @post1.id
    @comment1_1 = @post1.comments.create(:email => "comment1_1", :body => "Comment 1 for post 1")
    @comment2_1 = @post1.comments.create("email" => "comment1_2", :body => "Comment 2 for post 1")
    
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
    assert_nil Post.find_by_id(@post1_id)
    @post1 = Post.with_deleted.find(@post1_id)
    assert @post1.deleted_at
    @post1.revive
    assert 1, Post.count
  end
end
