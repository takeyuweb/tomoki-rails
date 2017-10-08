# Tomoki-kun

声を届ける能力

## 開発サーバー

例はUbuntuの場合。他の環境では便宜パッケージを読み替えてください。

### Ruby (rbenv)

    $ git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    $ cd ~/.rbenv && src/configure && make -C src
    $ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    $ echo 'eval "$(rbenv init -)"' >> ~/.bashrc
    $ source ~/.profile
    $ git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
    $ sudo apt-get install -y build-essential 
    $ rbenv install 2.4.2

### PostgreSQL library

    $ sudo apt-get install -y libpq-dev

### Node.js / yarn

    $ curl -sL https://deb.nodesource.com/setup_6.x | sudo bash -
    $ curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    $ echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    $ sudo apt-get update -qq
    $ sudo apt-get install -y nodejs yarn

### Docker CE / Docker Compose

1. https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-using-the-repository
2. https://docs.docker.com/engine/installation/linux/linux-postinstall/
3. https://github.com/docker/compose/releases

### Direnv (Optional)

    $ sudo apt-get install -y direnv
    $ echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
    $ source ~/.profile
    $ cd path-to/tomoaki-rails
    $ cp .envrc.sample .envrc
    $ vi .envrc
    $ direnv allow

### Start

#### bundle install / yarn

    $ bundle install --jobs 4 --retry 5 --path vendor/bundle
    $ yarn

#### database.yml

    $ cp config/database.yml.sample config/database.yml

### Start Servers

#### Creating a database

    $ export COMPOSE_FILE=docker-compose.development.yml
    $ docker-compose up -d
    $ bundle exec rails db:create
    $ bundle exec rails db:migrate

#### Start Rails

    $ bundle exec rails s

`export`による環境変数設定は、`direnv`を導入済みの場合不要です。（自動的に設定されます。）

### Stop Servers

    $ docker-compose stop

## Slack Apps

### Permissions

#### Add slash commands

#### users.profile:read

#### users:read
