class GroupRemitsController < InheritedResources::Base
  include Container
  include Counter
  
  before_action :authenticate_user!
  before_action :check_userable_type
  before_action :set_group_remit, only: %i[show edit update destroy submit]
  before_action :set_members, only: %i[new create edit update]

  def submit
    @group_remit.save_total_premium_and_fees

    respond_to do |format|
      if @group_remit.save
        format.html { redirect_to @group_remit, notice: "Group remit submitted" }
      else
        format.html { redirect_to @group_remit, alert: "Please see members below and complete the necessary details." }
      end
    end
  end

  def index
    @agreement = Agreement.find_by(id: params[:agreement_id])
    @group_remits = @agreement.group_remits
  end

  def show
    @agreement = @group_remit.agreement

    containers # controller/concerns/container.rb
    counters  # controller/concerns/counter.rb

    @pagy, @batches = pagy(@batches_container, items: 10)

  end

  def new
    @agreement = Agreement.find_by(id: params[:agreement_id])
    @group_remit = @agreement.group_remits.build(
      name: FFaker::Company.name, 
      description: FFaker::Lorem.paragraph, 
      agreement_id: 1, 
      anniversary_id: 1)
  end

  def create
    @agreement = Agreement.find_by(id: params[:agreement_id])
    @group_remit = @agreement.group_remits.build
    anniversary_date = set_anniversary(@agreement.anniversary_type, params[:anniversary_id])
    @group_remit.set_terms_and_expiry_date(anniversary_date)

    respond_to do |format|
      if @group_remit.save!
        format.html { redirect_to @group_remit, notice: "Group remit was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @agreement = @group_remit.agreement
  end

  def update
    # agreement = @group_remit.agreement

    # today = Date.today

    # if agreement.anniversary_type == "single" or agreement.anniversary_type == "multiple"
    #   anniversary_date = Anniversary.find_by(id: group_remit_params[:anniversary_id]).anniversary_date
    # else
    #   anniversary_date = today
    # end

    # terms = (anniversary_date.year * 12 + anniversary_date.month) - (today.year * 12 + today.month)

    # @group_remit.terms = terms <= 0 ? terms + 12 : terms
    # @group_remit.expiry_date = terms <= 0 ? anniversary_date.next_year : anniversary_date

    respond_to do |format|
      if @group_remit.update(group_remit_params)
        format.html { redirect_to @group_remit, notice: "Group remit was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @group_remit.destroy
        format.html { redirect_to agreements_path, alert: "Group remit was successfully deleted." }
      end
    end
  end


  private

    def set_group_remit
      @group_remit = GroupRemit.find_by(id: params[:id])
    end

    def set_members
      @members = Member.coop_member_details(@cooperative.coop_members)
    end

    def group_remit_params
      params.require(:group_remit).permit(:name, :description, :agreement_id, :anniversary_id)
    end

    def set_anniversary(anniversary_type, anniv_id)
      if anniversary_type == "single" || anniversary_type == "multiple"
        @group_remit.anniversary = Anniversary.find_by(id: anniv_id.to_i)
        @group_remit.anniversary.anniversary_date
      else
        Date.today
      end
    end

    def check_userable_type
      unless current_user.userable_type == 'CoopUser'
        render file: "#{Rails.root}/public/404.html", status: :not_found
      end
    end
end
