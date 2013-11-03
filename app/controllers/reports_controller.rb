class ReportsController < ApplicationController
  
  # GET /reports/new
  # GET /reports/new.json
  def new
    @report = Report.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @report }
    end
  end

  # POST /reports
  # POST /reports.json
  def create
    @report = Report.new(params[:report])
    @report.user = current_user

    respond_to do |format|
      if @report.save
        format.html { redirect_to @report.url, notice: 'We have recieved your release error report. Thank you for contributing.' }
        format.json { render json: @report, status: :created, location: @report }
      else
        format.html { render action: "new" }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    @report = Report.find(params[:id])
    @report.destroy

    respond_to do |format|
      format.html { redirect_to "/admin#tab3" }
      format.json { head :no_content }
    end
  end
end
