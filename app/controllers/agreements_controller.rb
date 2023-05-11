class AgreementsController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :check_userable_type
  before_action :set_cooperative, only: %i[index new create show]

  def index 
    @agreements = @cooperative.agreements.order(created_at: :desc)

    # filter members based on last name, first name
    @f_agreements = @agreements.where("name LIKE ?", "%#{params[:agreement_filter]}%")
    @pagy, @agreements = pagy(@f_agreements, items: 8)
  end

  def new
    @agreement = @cooperative.agreements.build(description: FFaker::Lorem.paragraph, premium: 1000, coop_service_fee: 10, agent_service_fee: 5, plan_id: 1)
  end

  def create
    @agreement = @cooperative.agreements.build(agreement_params)
    plan = Plan.find_by(id: agreement_params[:plan_id])
    @agreement.name = Agreement.exists? ? "#{plan.acronym}-Agreement-#{Agreement.last.id + 1}" : "#{plan.acronym}-Agreement-1"
    
    respond_to do |format|
      if @agreement.save!
        format.html { redirect_to @agreement, notice: 'Agreement was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  private

    def agreement_params
      params.require(:agreement).permit(:description, :premium, :coop_service_fee, :agent_service_fee, :plan_id, :anniversary_type, :agreement_type)
    end

    def set_cooperative
      @cooperative = current_user.userable.cooperative
    end

    def check_userable_type
      unless current_user.userable_type == 'CoopUser'
        render file: "#{Rails.root}/public/404.html", status: :not_found
      end
    end
end
