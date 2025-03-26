class WhatsappApiService
  include HTTParty

  def initialize(api_key, api_version = '22.0')
    @headers = {
      'Authorization' => "Bearer #{api_key}",
      'Content-Type' => 'application/json'
    }
    self.class.base_uri "https://graph.facebook.com/v#{api_version}"
  end

  def send_message(phone_number_id, message_body)
    self.class.post("/#{phone_number_id}/messages", headers: @headers, body: message_body.to_json)
  end

  def send_choose_language_message(phone_number_id, to)
    message_body = {
      messaging_product: 'whatsapp',
      to: to,
      type: 'interactive',
      interactive: {
        type: 'button',
        header: {
          type: 'text',
          text: 'Choose Option/Elija la opción'
        },
        body: {
          text: 'Choose Language/Elegir Idioma:'
        },
        action: {
          buttons: [
            {
              type: 'reply',
              reply: {
                id: 'espanol',
                title: 'Español'
              }
            },
            {
              type: 'reply',
              reply: {
                id: 'english',
                title: 'English'
              }
            }
          ]
        }
      }
    }
    self.class.post("/#{phone_number_id}/messages", headers: @headers, body: message_body.to_json)
  end

  def send_flow_message(phone_number_id, to, flow_id, language)
    body_text = if language == :es
                  'Por favor complete este formulario con su informe de análisis de suelo.'
                else
                  'Please fill in this form with your soil analysis report.'
                end
    flow_cta = if language == :es
                 'Rellenar formulario'
               else
                 'Fill Form'
               end
    message_body = {
      messaging_product: 'whatsapp',
      to: to,
      type: 'interactive',
      interactive: {
        type: 'flow',
        body: {
          text: body_text
        },
        action: {
          name: 'flow',
          parameters: {
            flow_message_version: '3',
            flow_id: flow_id,
            flow_cta: flow_cta,
            mode: 'published',
            flow_action: 'navigate',
            flow_action_payload: {
              screen: 'RECOMMEND',
              data: {
                phone_number: to
              }
            }
          }
        }
      }
    }
    self.class.post("/#{phone_number_id}/messages", headers: @headers, body: message_body.to_json)
  end

  def send_result_pdf_message(phone_number_id, to, pdf_url, pdf_name, caption)
    message_body = {
      messaging_product: 'whatsapp',
      to:,
      type: 'document',
      document: {
        link: pdf_url,
        filename: pdf_name,
        caption:
      }
    }
    self.class.post("/#{phone_number_id}/messages", headers: @headers, body: message_body.to_json)
  end

  def send_preparing_result_message(phone_number_id, to, language)
    body_text = if language == :es
                  'Estamos preparando su informe de análisis de suelo. Por favor espere.'
                else
                  'Please hold on while we generate your report.'
                end
    message_body = {
      messaging_product: 'whatsapp',
      to:,
      type: 'text',
      text: {
        body: body_text
      }
    }
    self.class.post("/#{phone_number_id}/messages", headers: @headers, body: message_body.to_json)
  end

  def send_end_message(phone_number_id, to, language)
    body_text = if language == :es
                  'Di Hola, si deseas ejecutar otro informe.'
                else
                  'Say Hi, if you would like to run another report.'
                end
    message_body = {
      messaging_product: 'whatsapp',
      to:,
      type: 'text',
      text: {
        body: body_text
      }
    }
    self.class.post("/#{phone_number_id}/messages", headers: @headers, body: message_body.to_json)
  end
end
