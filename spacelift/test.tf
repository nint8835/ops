data "http" "this_file" {
  url = "http://100.122.52.123:8000/test.tf"
}

output "file_content" {
  value = data.http.this_file.body
}
