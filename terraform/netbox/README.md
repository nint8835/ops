# netbox

Configuration for [NetBox](https://netbox.dev/).

## Usage

- Clone [netbox-docker](https://github.com/netbox-community/netbox-docker)
- Follow the quickstart instructions to start netbox & create a superuser account
- Go to http://localhost:8000 and log in as the newly created user
- Click your username in the top right, then click "API Tokens"
- Click "Add a Token", then create. Copy the created key.
- Create a file called `terraform.tfvars` in this directory with the following contents:

```hcl
netbox_token = "YOUR_TOKEN_HERE"
```

You can then use the normal suite of terraform commands like usual.
