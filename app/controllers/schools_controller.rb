class SchoolsController < ApplicationController
  
  def show_language_courses
    @type = 1
    @schools = School.all.where(:type_school=>@type)
    respond_to do |format|
      format.html { render 'schools/show' }
      format.xls { render 'schools/show' }
    end
  end
  
  def show_universities
    @type = 2
    @schools = School.all.where(:type_school=>@type)
    respond_to do |format|
      format.html { render 'schools/show' }
      format.xls { render 'schools/show' }
    end
  end
  
  def show_private_schools
    @type = 3
    @schools = School.all.where(:type_school=>@type)
    respond_to do |format|
      format.html { render 'schools/show' }
      format.xls { render 'schools/show' }
    end
  end
  
  def show_lyceums
    @type = 4
    @schools = School.all.where(:type_school=>@type)
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
