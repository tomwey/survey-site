# coding: utf-8
class Question < ActiveRecord::Base
  attr_accessible :sort, :tip, :title, :type_id, :answers_attributes
  
  belongs_to :survey
  has_many :answers, :dependent => :destroy
  accepts_nested_attributes_for :answers, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true
  
  QUESTION_TYPES = [['文本', 1], ['单选框',2], ['复选框', 3], ['文本内容', 4]]
end
