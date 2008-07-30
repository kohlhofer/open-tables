require '../test_helper'

class ItemTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_01_sti
    v = Video.create!(:title => 'first video', :source => 'http://www.youtube.com/v/gtACE-uwDxM')
    assert_equal "Video", Item.find(v.id).class.name
  end
end
