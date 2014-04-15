require './lib/polycene/license.rb'

class OntologiesController < ApplicationController
	before_action :set_ontology, only: [:show, :edit, :generate_license, :new_action, :download, :update, :destroy]

	# GET /ontologies
	# GET /ontologies.json
	def index
		@ontologies = Ontology.all
	end

	# GET /ontologies/1
	# GET /ontologies/1.json
	def show
	end

	# GET /ontologies/new
	def new
		@ontology = Ontology.new
	end

	# GET /ontologies/1/edit
	def edit
	end

	# POST /ontologies
	# POST /ontologies.json
	def create
		@ontology = Ontology.new(ontology_params)

		file = params[:ontology][:file]
		name = file.original_filename

		@ontology.filetype = File.extname(name)
		@ontology.url = "./public/ontologies/#{@ontology.name}#{@ontology.filetype}"

		File.open(@ontology.url, 'wb') { |f| f.write file.read }

		respond_to do |format|
			if @ontology.save
				format.html { redirect_to "/ontologies"}
				format.json { render action: 'show', status: :created, location: @ontology }
			else
				format.html { render action: 'new' }
				format.json { render json: @ontology.errors, status: :unprocessable_entity }
			end
		end
	end


	def generate_license
		@con = Polycene::Context.new
		@con.populate @ontology.url
	end


	def new_action
		@con = Polycene::Context.new
		@con.populate @ontology.url
		@number = params[:number]

		render partial: 'action'
	end


	def download
		send_file @ontology.url
	end

	# PATCH/PUT /ontologies/1
	# PATCH/PUT /ontologies/1.json
	def update
		respond_to do |format|
			if @ontology.update(ontology_params)
				format.html { redirect_to @ontology, notice: 'Ontology was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: 'edit' }
				format.json { render json: @ontology.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /ontologies/1
	# DELETE /ontologies/1.json
	def destroy
		File.delete(@ontology.url)
		@ontology.destroy
		respond_to do |format|
			format.html { redirect_to ontologies_url }
			format.json { head :no_content }
		end
	end

	private
		# Use callbacks to share common setup or constraints between actions.
		def set_ontology
			@ontology = Ontology.find(params[:id])
		end

		# Never trust parameters from the scary internet, only allow the white list through.
		def ontology_params
			params.require(:ontology).permit(:name, :url)
		end
end
