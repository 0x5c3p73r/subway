# 🚉 Subway

You're waiting for a train, a train that will take you far away.
You know where you hope this train will take you, but you don't know for sure. But it doesn't matter.
How can it not matter to you where that train will take you? Because you'll be together.

![Intro](docs/assets/images/intro.png)

## Features

- 🤹‍♂️ Generate one unqiue url, use anywhere.
- 🔐 [Encrypt secret data](https://guides.rubyonrails.org/active_record_encryption.html), less leak from database.
- 🎫 Anonymous ticket, keep your privacy.
- 🔍 Open source, review user's safty.

## Usage

1. Customize rules and generate your coach.
1. Hold on to your ticket and get on the right number `Permalink`.
1. Update, destroy the coach with your ticket.

## Deploy

### Docker

1. Download [docker-compose.yml](https://raw.githubusercontent.com/0x5c3p73r/subway/main/docker-compose.yml) file
1. [Generate](https://subway-naf0.onrender.com/tools/encrypted_data) master key and encrypted data.
1. Copy master key to `RAILS_MASTER_KEY` and encrypted data to `RAILS_ENCRYPTED_DATA` in `docker-compose.yml`
1. Connect database
  1. Skip this step to use docker-compose's db service (default)
  1. Use external database, change the `DATABASE_URL` value.
1. Run it with `docker-compose up`

## All encrypted

The private data generated by the project demo address are encrypted and can be safely consumed,
the following url is the full data of the database: https://pgweb-518a.onrender.com/
