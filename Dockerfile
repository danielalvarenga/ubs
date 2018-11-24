# Set linux Alpine 3.8 image with ruby 2.5 installed
# Others oficial ruby images: https://hub.docker.com/_/ruby/
FROM ruby:2.5-alpine3.8

# Install required libraries and dependencies
RUN apk add --update --no-cache \
      build-base \
      nodejs \
      tzdata \
      libxml2-dev \
      libxslt-dev \
      bash \
      postgresql-dev \
      mysql-dev \
      imagemagick

# Set timezone
RUN cp /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
RUN echo "America/Sao_Paulo" >  /etc/timezone

# Update CA Certificates
RUN update-ca-certificates

# Set rails env variable
ARG bundle_options_var='--without development test'
# Application path inside container
ENV APP_ROOT /app

# Create application folder
RUN mkdir $APP_ROOT
# Set command execution path
WORKDIR $APP_ROOT

# Copy files to application folder
COPY Gemfile $APP_ROOT/Gemfile
COPY Gemfile.lock $APP_ROOT/Gemfile.lock

# Install gems
RUN bundle config --global frozen 1
RUN bundle install $bundle_options_var

# Copy all project files to application folder inside container
COPY . $APP_ROOT

# CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]