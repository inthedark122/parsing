class SchoolsController < ApplicationController
  
  def show_language_courses
    @schools = School.all.where(:type_school=>1)
    respond_to do |format|
      format.html { render 'schools/show' }
      format.xls { render 'schools/show' }
    end
  end
  
  def show_universities
    @schools = School.all.where(:type_school=>2)
    respond_to do |format|
      format.html { render 'schools/show' }
      format.xls { render 'schools/show' }
    end
  end
  
  def show_private_schools
    @schools = School.all.where(:type_school=>3)
    respond_to do |format|
      format.html { render 'schools/show' }
      format.xls { render 'schools/show' }
    end
  end
  
  def show_lyceums
    @schools = School.all.where(:type_school=>4)
    respond_to do |format|
      format.html { render 'schools/show' }
      format.xls { render 'schools/show' }
    end
  end
  
  def school_parse(type, params)
    case type
    when 1
      School.new().language_courses_parse(params)
    when 2
      School.new().universities_parse(params)
    when 3
      School.new().private_schools_parse(params)
    when 4
      School.new().lyceums_parse(params)
    end
  end
  
end
