class PackagesController < ApplicationController
  before_action :authenticate_user!
  
  def create
    user = User.find(params[:user_id])
    selected_packages = packages_params[:selectedPackages]

    unless user.present? && selected_packages.is_a?(Array)
      render json: { error: 'Invalid request parameters' }, status: :unprocessable_entity
      return
    end

    selected_packages.each do |package_data|
      user.packages.create(name: package_data[:name], amount: package_data[:amount])
    end

    render json: { message: 'Packages created successfully' }, status: :created
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
  rescue StandardError => e
    render json: { error: "Error creating packages: #{e.message}" }, status: :unprocessable_entity
  end

  private

  def packages_params
    params.permit(selectedPackages: [:name, :amount])
  end
end
