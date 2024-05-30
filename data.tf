data "template_file" "open_ai_spec" {
  template = file("${path.module}/assets/api_spec/open_ai_spec.json")
}

data "template_file" "global_open_ai_policy" {
  template = file("${path.module}/assets/policies/global_open_ai_policy.xml")
}