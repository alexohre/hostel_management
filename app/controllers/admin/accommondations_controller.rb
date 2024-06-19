class Admin::AccommondationsController < AdminController

  def index 
    @accommondations = Accommondation.includes(:account).order(id: :desc)
  end

  def print
    @accommondation = Accommondation.find(params[:id])
    pdf = AccommondationPdfService.new(@accommondation).generate

    send_data pdf, filename: "Accommondation_Invoice_#{@accommondation.ref_no}.pdf",
                   type: 'application/pdf',
                   disposition: 'attachment' # or 'attachment' for download
  end

end