class Registration < ActiveRecord::Base
  attr_accessible :repository, :topic, :test_url, :active, :review1, :review2, :language

  belongs_to :course
  belongs_to :user
  has_many :week_feedbacks
  

  validates :test_url,
            :format => { :with => /https?:\/\/.+/,
            :message => "copy/paste your works running address (usually http://username.users.cs.helsinki.fi/) here from the browser address line" }

  validates :repository,
            :format => { :with => /https:\/\/github.com\/.+\/.+/,
            :message => "copy/paste your repo address here from the browser address line" }

  def self.registrations_for course
    Registration.where( :course_id => course.id ).includes(:user, :week_feedbacks)
  end

  def self.current
    Registration.all.select { |r| r.course.active }
  end

  def self.past
    Registration.all.reject { |r| r.course.active }
  end

  def self.review_participants course
    Registration.select do |r|
      r.course = course and r.participates_review course.review_round
    end
  end

  def total_points
    return grade_feedback.points unless grade_feedback.nil?
    points = 0
    week_feedbacks.select {|f| !f.is_grade }.each { |f|
      points+= f.points
    }
    points += review1 unless review1.nil?
    points += review2 unless review2.nil?
    points
  end

  def grade_points
    return nil if grade_feedback.nil?
    points = grade_feedback.points 
    week_feedbacks.select {|f| !f.is_grade }.each { |f|
      points-= f.points
    }
    points -= review1 unless review1.nil?
    points -= review2 unless review2.nil?
    points
  end
  def grade_feedback
    week_feedbacks.find_by_is_grade true
  end


  def has_instructor_notes
    week_feedbacks.each do |fb|
      return true unless fb.hidden_text.nil? or fb.hidden_text.empty?
    end

    false
  end

  def last_instructor_note_digest
    #max = week_feedbacks.inject(0) { |m, fb| m = fb.week if fb.week>m; m }
    #if max>6
    #  return feedback_for_week(max).hidden_text
    #end
    #
    #[6, 5, 4, 3, 2, 1].each do |w|
    #  fb = feedback_for_week w
    #  return fb.hidden_text unless fb.nil? or fb.hidden_text.nil? or fb.hidden_text.empty?
    #end
    week_feedbacks.sort_by{ |f| f.updated_at }.reverse.each do |fb|
      return fb.hidden_text unless fb.nil? or fb.hidden_text.nil? or fb.hidden_text.empty?
    end

    ""
  end

  def toggle_activity
    self.active = active==false

    if not active
      PeerReview.all.select { |r| r.reviewer == self or r.reviewed == self }.each do |p|
        p.delete if p.round == Course.active.review_round
      end
      self.participate_review1 = false
      self.participate_review2 = false
    end
  end

  def toggle_review_participation round
    if round==1
      self.participate_review1 = participate_review1 ? false : true
    else
      self.participate_review2 = participate_review2 ? false : true
    end

    unless participates_review round
      PeerReview.all.select { |r| r.round == round and (r.reviewer == self or r.reviewed == self) }.each do |p|
        p.delete
      end
    end
  end

  def participates_review round
    return participate_review1 if round==1
    participate_review2
  end

  def review_targets_for round
    review_targets.select { |p| p.round == round }
  end

  def review_targets
    PeerReview.select { |p| p.reviewer_id == id }
  end

  def reviewers_for round
    reviewers.select { |p| p.round == round }
  end

  def reviewers
    PeerReview.select { |p| p.reviewed_id == id }
  end

  def feedback_given
    "#{feedback.map(&:week)}"[1..-2]
    (1..course.weeks_total).inject("") { |points, n|
      points += (points_for_week n)+" "
    }
  end

  def review_status
    r1 = review_targets_for 1
    r2 = review_targets_for 2
    ([stringify(r1), stringify(r2)]).join(" ")
  end

  def review_status_for_week week
    return review1 if not review1.nil? and week==1
    return review2 if not review2.nil? and week==2
    stringify(review_targets_for week)
  end

  def stringify r
    return "-" if  r.empty?
    return "X"
    return "todo" if not r.first.done
    "DONE"
  end

  def feedback
    week_feedbacks.sort_by { |f| f[:week] }
  end

  def points_for_week week
    week_feedbacks.each { |f|
      return f.points.to_s if f.week == week
    }
    return "-"
  end

  def feedback_for_week week
    week_feedbacks.each { |f|
      return f if f.week == week
    }
    return nil
  end


  def reviewed_in_round student, round
    review_status = status_in_round( self.review_targets, student, round )
    return "" if review_status == nil
    return "X"
    return "todo" if review_status==false
    "DONE"
  end

  def status review_targets, searched
    review_targets.each { |r|
      return r.done if r.reviewed == searched
    }
    nil
  end

  def status_in_round review_targets, searched, round
    review_targets.each { |r|
      return r.done if r.reviewed == searched and r.round == round
    }
    nil
  end

  def includes? review_targets, searched
    review_targets.each { |r|
      return true if r.reviewed == searched
    }

    false
  end


end
