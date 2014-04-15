require './lib/polycene/license.rb'
require 'coderay'

class LicensesController < ApplicationController
	before_action :set_license, only: [:show, :edit, :download, :update, :destroy]

	# GET /licenses
	# GET /licenses.json
	def index
		@licenses = License.all
	end

	# GET /licenses/1
	# GET /licenses/1.json
	def show
		file = File.open @license.url

		@doc = CodeRay.scan file.read, :xml
		@doc = @doc.div(:css => :class)
		#xml = Document.new file

		#formatter = Formatters::Pretty.new(4)
		#@doc = String.new
		#formatter.write(xml, @doc)
	end

	# GET /licenses/new
	def new
		@license = License.new
	end

	# GET /licenses/1/edit
	def edit
	end

	# POST /licenses
	# POST /licenses.json
	def create

		license_object = Polycene::License.new "testing"

		params[:actions].keys.each_with_index do |k, i|
			license_object.add_action i+1, params[:actionname][k]
			
			params[:actions][k].keys.each_with_index do |ra, ri|
				license_object.add_restricted_activity i+1, ra
				params[:actions][k][ra].keys.each do |r|
					license_object.add_restriction i+1, ri+1, r, params[:actions][k][ra][r][:function], params[:actions][k][ra][r][:value]
				end
			end
		end

		@ontology = Ontology.find params[:ontology_id]
		@license = @ontology.licenses.new

		@license.name = params[:licname]
		@license.url = "./public/licenses/#{@license.name}.xml"

		license_object.build_license @license.url

		respond_to do |format|
			if @license.save
				format.html { redirect_to @license, notice: 'License was successfully created.' }
				format.json { render action: 'show', status: :created, location: @license }
			else
				format.html { render action: 'new' }
				format.json { render json: @license.errors, status: :unprocessable_entity }
			end
		end

	end

	def download
		send_file @license.url
	end

	# PATCH/PUT /licenses/1
	# PATCH/PUT /licenses/1.json
	def update
		respond_to do |format|
			if @license.update(license_params)
				format.html { redirect_to @license, notice: 'License was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: 'edit' }
				format.json { render json: @license.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /licenses/1
	# DELETE /licenses/1.json
	def destroy
		File.delete(@license.url)
		@license.destroy
		respond_to do |format|
			format.html { redirect_to licenses_url }
			format.json { head :no_content }
		end
	end

	private
		# Use callbacks to share common setup or constraints between actions.
		def set_license
			@license = License.find(params[:id])
		end

		# Never trust parameters from the scary internet, only allow the white list through.
		def license_params
			params.require(:license).permit(:name, :ontology_id)
		end
end
