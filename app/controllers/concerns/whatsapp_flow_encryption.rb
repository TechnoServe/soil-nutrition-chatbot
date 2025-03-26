module WhatsappFlowEncryption
  extend ActiveSupport::Concern

  def decrypt_request(encrypted_flow_data, aes_key, iv_key)
    flow_data = Base64.decode64(encrypted_flow_data)
    iv = Base64.decode64(iv_key)
    encrypted_aes_key = Base64.decode64(aes_key)

    private_key_string = Rails.application.credentials.dig(:meta, :private_key)
    passphrase = Rails.application.credentials.dig(:meta, :passphrase)
    private_key = OpenSSL::PKey::RSA.new(private_key_string, passphrase)

    d_aes_key = JOSE::JWA::PKCS1.rsaes_oaep_decrypt(OpenSSL::Digest::SHA256, encrypted_aes_key, private_key)

    encrypted_flow_data_body = flow_data[0...-16]
    encrypted_flow_data_tag = flow_data[-16..]

    cipher = OpenSSL::Cipher.new('aes-128-gcm')
    cipher.decrypt
    cipher.key = d_aes_key
    cipher.iv_len = iv.bytesize
    cipher.iv = iv
    cipher.auth_tag = encrypted_flow_data_tag

    decrypted_data_bytes = cipher.update(encrypted_flow_data_body) + cipher.final
    decrypted_data = JSON.parse(decrypted_data_bytes)

    [decrypted_data, d_aes_key, iv]
  end

  def encrypt_response(response, aes_key, iv)
    flipped_iv = iv.bytes.map { |byte| byte ^ 0xFF }

    cipher = OpenSSL::Cipher.new('aes-128-gcm')
    cipher.encrypt
    cipher.key = aes_key
    cipher.iv_len = iv.bytesize
    cipher.iv = flipped_iv.pack('C*')

    encrypted_data = cipher.update(response.to_json) + cipher.final
    tag = cipher.auth_tag

    Base64.encode64(encrypted_data + tag).strip
  end
end
