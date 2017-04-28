class Shortcode < Grape::Validations::Base
  SHORTCODE_REGEX = /^[0-9a-zA-Z_]{4,}$/

  def validate_param!(attr_name, params)
    raise malformed_error unless @option.match? params[attr_name]
  end

  def malformed_error
    Shorty::Errors::ShortcodeMalformedError
  end
end
