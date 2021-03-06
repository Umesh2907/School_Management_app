class SchoolsController < ApplicationController
  def index
    @schools = School.all
      respond_to do |format|
        format.html
        format.json { render json: SchoolDatatable.new(params, view_context: view_context) }
        format.csv { send_data @schools.to_csv(['school_name', 'description', 'address', 'classes']) }
      end
  end

  def import
    School.import(params[:file])
    redirect_to schools_path, notice: "School imported."
 end

  def show
    @school = School.find(params[:id])
    @teachers = @school.teachers.count
    @students = @school.students.count
  end

  def new 
    @school = School.new
  end

  def edit 
    @school = School.find(params[:id])
  end

  def create
    @school = School.new(school_params)

    if @school.save
      redirect_to @school
    else
      render 'new'
    end
  end

  def update
    @school = School.find(params[:id])

    if @school.update(school_params)
      redirect_to @school
    else
      render 'edit'
    end
  end

  def destroy
    @school = School.find(params[:id])
    @school.destroy

    redirect_to schools_path
  end

  private
  def school_params
    params.require(:school).permit(:school_name, :description, :address, :classes)
  end
end
