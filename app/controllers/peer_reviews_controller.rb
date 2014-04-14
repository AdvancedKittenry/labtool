class PeerReviewsController < ApplicationController
  skip_before_filter :authenticate, :only => [ :complete_review, :toggle_participation ]

  def complete_review
    review = PeerReview.find(params[:review])
    review.update_attributes :done => true

    redirect_to "/mypage/#{review.reviewer.user.student_number}"
  end

  def toggle_participation
    @registration = Registration.find(params[:registration])
    @registration.toggle_review_participation params[:round].to_i
    @registration.save
    redirect_to :back, :notice => 'Code review participation status changed'
    #redirect_to "/mypage/#{@registration.user.student_number}", :notice => 'Code review participation status changed'
  end

  def generate
    begin
      generate_peer_review_assignment
    end until unique_assignment

    redirect_to peer_reviews_path, :notice => "default review assignments generated for the current review round"
  end

  def reset
    PeerReview.delete_for Course.active
    redirect_to peer_reviews_path, :notice => "peer review assignments for the current review round reset"
  end

  def remove_review
    reviewer = User.find(params[:reviewer]).current_registration
    reviewed = User.find(params[:reviewed]).current_registration
    round = reviewer.course.review_round

    review = PeerReview.find_matching reviewer, reviewed, round
    review.delete

    redirect_to :back
  end

  def create
    reviewer = User.find(params[:peer_review][:reviewer_id]).current_registration
    reviewed = User.find(params[:peer_review][:reviewed_id]).current_registration

    create_peer_review reviewer, reviewed

    redirect_to :back
  end

  def toggle_review
    reviewer = User.find(params[:reviewer]).current_registration
    reviewed = User.find(params[:reviewed]).current_registration
    round = reviewer.course.review_round

    review = PeerReview.find_matching reviewer, reviewed, round

    if review.nil?
      create_peer_review reviewer, reviewed
      @label = "cancel"
    else
      review.delete
      @label = "review"
    end

    prepare_for_js reviewer, reviewed

    respond_to do |format|
      format.js
    end
  end

  def prepare_for_js(reviewer, reviewed)
    reviewer_id = reviewer.user.id
    reviewed_id = reviewed.user.id

    @reviewer_class = class_for reviewer, 'review'

    @reviewed_class = class_for reviewed, 'reviewer'

    @selector = "#b#{reviewer_id}-#{reviewed_id} form input:last"
    @class_selector = "#b#{reviewer_id}-#{reviewed_id}"
    @student_selector = "#s#{reviewer_id}"
    @review_target_selector = "#r#{reviewed_id}"
    @reviews_count_selector = "#reviews#{reviewer_id}"
    @reviewers_count_selector = "#reviewers#{reviewed_id}"
    @reviewers_count = reviewed.user.assigned_reviewers.count
    @reviews_count = reviewer.user.assigned_reviews.count
  end

  def index
    @peer_reviews = PeerReview.current_round_for Course.active

    @students = User.select do |s|
      s.current_registration and
      s.current_registration.participates_review(Course.active.review_round) and
      s.current_registration.active
    end
    @students.sort_by!{ |s| s.surename}

    #TODO
    @course = Course.active

    @reviewer_candicate = @students.reject{|s| s.reviewer_at_round?(@course.review_round) }
    @review_target_candidate =  @students.reject{|s| s.review_target_at_round?(@course.review_round) }
  end

  private

  def reviewers_by_language
    reviewers = User.review_participants.map(&:current_registration).group_by(&:language)
    
    # Make sure that all the groups are big enough
    leftovers = []
    leftover_languages = []
    reviewers.reject! do |lang, language_reviewers|
      if language_reviewers.size < 2
        leftovers += language_reviewers
        leftover_languages << lang
        true
      else
        false
      end
    end
    
    # Add fringe languages to their own group or a larger group as needed
    unless leftovers.empty?
      leftover_languages = leftover_languages.join(", ")
      if leftovers.size >= 2
        reviewers[leftover_languages.gsub(/, ([^,]*)$/, ' and \1')] = leftovers
      elsif not reviewers.empty?
        firstgroup = reviewers[reviewers.keys.first]
        key = reviewers.keys.first or "Unknow language"
        
        leftover_languages = key + " and " + leftover_languages
        
        reviewers.delete reviewers.keys.first
        reviewers[leftover_languages] = firstgroup + leftovers 
      end
    end

    return reviewers
  end

  def do_pairing
    #Group participants by programming language

    result = []

    reviewers_by_language.each do |lang, reviewers|
      review_targets = reviewers.map(&:id).shuffle

      reviewers.inject(result) do |result, reviewer|
        target = review_targets.first
        review_targets.slice!(0)
        result << [reviewer.id, target]
      end
    end

    result
  end

  def valid_pairing(pairs, trials)
    pairs.each { |pair|
      return false if pair.first == pair.last
    }

    # it could be possible that a totally nonsymmetrical assignment can not be created
    return true if trials == 10

    otherw = pairs.inject([]) { |result, pair|
      result << [ pair.last, pair.first ]
    }

    (pairs&otherw).empty?
  end

  def generate_peer_review_assignment
    PeerReview.delete_for Course.active

    trials = 0
    begin
      pairs = do_pairing
      trials += 1
    end until valid_pairing pairs, trials

    pairs.each do |pair|
      create_peer_review Registration.find(pair.first), Registration.find(pair.last)
    end

  end

  def unique_assignment
    return true if Course.active.review_round == 1

    # there exists some cases where an unique assignment is not possible,.. the following is for those
    @trials ||= 0
    @trials += 1
    return true if @trials == 20

    this_round = PeerReview.current_round_for Course.active
    prev_round = PeerReview.for Course.active, 1
    this_round.each do |this|
      prev_round.each do |prev|
        return false if this.reviewer == prev.reviewer and this.reviewed == prev.reviewed
      end
    end

    true
  end

  def create_peer_review(reviewer, reviewed)
    round = reviewer.course.review_round
    peer_review = PeerReview.new :done => :false, :round => round
    peer_review.reviewer = reviewer
    peer_review.reviewed = reviewed
    peer_review.save if reviewer != reviewed
  end

  def class_for object, klass
    method = "assigned_#{klass}s".to_sym
    count = object.user.send(method).count
    if count > 1
      return "many-#{klass}s-assigned"
    elsif count == 1
      return "#{klass}-assigned"
    end
    ""
  end

end
