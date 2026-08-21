# Rails 8 User Invitations

A simple user invitation system built with Rails 8's native authentication.
Read the full implementation guide [here](https://medium.com/deemaze-software/user-invitations-with-rails-8-authentication-ba229fab466).

## What it does

- Existing users can invite new users by email
- Invitees get a secure link to set up their password
- No open registration - invitation-only access
- Uses Rails 8's built-in authentication (no Devise)

## Quick Start

```bash
git clone https://github.com/sofmeireles/rails8-invitations.git
cd rails8-invitations
bundle install
rails db:setup
bin/dev
```

**Demo login:**
- Email: `demo@example.com`
- Password: `password`

## How it works

1. User sends invitation → creates account with temp password
2. Invitee gets email with secure token link
3. They set their password and account is activated

Built using Rails' `generates_token_for` for secure, expiring tokens.

## Blog Post

Read the full implementation guide: https://medium.com/deemaze-software/user-invitations-with-rails-8-authentication-ba229fab466e 
