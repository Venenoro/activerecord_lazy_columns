# frozen_string_literal: true

require "test_helper"
require "active_record/testing/query_assertions"

# class LazyColumnsTest < Minitest::Test
class LazyColumnsTest < ActiveSupport::TestCase
  include ActiveRecord::Assertions::QueryAssertions

  def test_do_not_load_lazy_columns
    assert_queries_match(/"users"."name"/) do
      assert_no_queries_match(/"users"."bio"/) do
        User.last
      end
    end
  end

  def test_loads_lazy_columns_on_demand
    user = User.last
    assert_queries_match(/"users"."bio"/) do
      user.bio
    end

    assert_no_queries do
      # Once again.
      user.bio
    end

    assert user.bio.present?
    assert_not user.changed?
  end

  def test_assigning_to_lazy_columns
    user = User.last

    assert_no_queries do
      user.bio = "Test"
    end
    assert user.changed?
  end

  def test_pluck_lazy_columns
    assert_equal ["Very long text"], User.pluck(:bio)
  end

  def test_model_count
    assert_equal 1, User.count
    assert_equal 1, User.count(:id)
  end

  def test_column_names
    assert_equal ["id", "name", "bio"], User.column_names
  end

  def test_explicitly_selecting_columns
    assert_queries_match(/"users"."bio"/) do
      User.select(:bio).to_a
    end
  end
end
