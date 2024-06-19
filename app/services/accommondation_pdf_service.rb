# app/services/accommondation_pdf_service.rb

require 'prawn'
require 'prawn/table'

class AccommondationPdfService
  def initialize(accommondation)
    @accommondation = accommondation
  end

  def generate
    Prawn::Document.new do |pdf|
      # Register and use a UTF-8 compatible font
      pdf.font_families.update("Roboto" => {
        normal: "#{Rails.root}/app/assets/fonts/Roboto-Regular.ttf",
        bold: "#{Rails.root}/app/assets/fonts/Roboto-Bold.ttf",
        italic: "#{Rails.root}/app/assets/fonts/Roboto-Italic.ttf",
        bold_italic: "#{Rails.root}/app/assets/fonts/Roboto-BoldItalic.ttf"
      })
      pdf.font "Roboto"

      # Invoice header
      pdf.bounding_box([0, pdf.cursor], width: pdf.bounds.width) do
        pdf.bounding_box([pdf.bounds.width * 0.25, pdf.cursor], width: pdf.bounds.width * 0.5) do

          pdf.image "#{Rails.root}/app/assets/images/img/dspg_logo.png", width: 150, position: :center
        end
        pdf.bounding_box([0, pdf.cursor], width: pdf.bounds.width * 0.5) do
          pdf.move_down 10
          pdf.text "Delta State Polytechnic", size: 24, style: :bold
          pdf.text "Ogwashi-uku", size: 16
          pdf.move_down 10
          pdf.text "123 Main Street, Cityville, Country"
          pdf.text "Email: hostel@mydspg.edu.ng"
          pdf.text "Phone: +1 234-567-8901"
        end
        pdf.bounding_box([pdf.bounds.width * 0.5, pdf.cursor + 70], width: pdf.bounds.width * 0.5) do
          pdf.text "Invoice", size: 30, style: :bold, align: :right
          pdf.move_down 10
          pdf.text "Invoice No: #{@accommondation.ref_no}", align: :right
          pdf.text "Date: #{@accommondation.created_at.strftime('%b %d, %Y')}", align: :right
        end
        pdf.move_down 20
      end

      # Invoice table
      pdf.table(invoice_table_data, width: pdf.bounds.width) do
        row(0).font_style = :bold
        row(0).background_color = 'e64a19'
        row(0).text_color = 'ffffff'
        row(0).align = :center
        cells.padding = 10
        cells.border_width = 1
        cells.border_color = '000000'
        cells.align = :center
      end

      pdf.move_down 20

      # Footer
      pdf.bounding_box([0, pdf.cursor], width: pdf.bounds.width * 0.5) do
        pdf.text "Student Details", size: 16, style: :bold
        pdf.move_down 10
        pdf.text "Matric No: #{@accommondation.account.mat_no.upcase}", size: 14, style: :bold
        pdf.text "Name: #{@accommondation.account.first_name} #{@accommondation.account.last_name}", size: 14
      end
      pdf.bounding_box([pdf.bounds.width * 0.5, pdf.cursor + 70], width: pdf.bounds.width * 0.5) do
        pdf.text "Total: #{number_to_currency(@accommondation.amount, unit: '₦')}", size: 16, style: :bold, align: :right
      end

      pdf.move_down 40
      pdf.text "Thank you!", size: 20, style: :italic, align: :center
    end.render
  end

  private

  def invoice_table_data
    [
      ["Hostel", "Room Type", "Room No / Bed", "Session", "Amount"],
      [
        @accommondation.hostel,
        @accommondation.room_type,
        "#{@accommondation.room_no} / #{@accommondation.bed}",
        @accommondation.session,
        number_to_currency(@accommondation.amount, unit: "₦")
      ]
    ]
  end

  def number_to_currency(number, options = {})
    ActionController::Base.helpers.number_to_currency(number, options)
  end
end
