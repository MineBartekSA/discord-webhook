# Composite Discord Webhooks

Github Actions for sending messages through Discord's Webhooks

Unlike other actions, this action is based on composite actions, meaning it doesn't need to build and works on every runner.

## Usage

```yaml
- name: 'Send basic message to Discord'
  uses: MineBartekSA/discord-webhook@v1.4
  with:
    webhook: ${{ secrets.WEBHOOK_URL }}
    content: 'Hello Discord'
```
> **Note:** There is no runner restriction. Any will do.

> **⚠️Warning:** Do not use this action multiple times in a single job! This is due a bug in Github Actions.\
> You can read about it more [here](https://github.com/actions/runner/issues/789) or on the [fix PR](https://github.com/actions/runner/pull/1794) that is merged but not deployed _(as of 10.08.2022)_.

For debuging purpouses, it is strongly suggested to add `/v10/` path segment after the `/api/` segment in your webhook url.

### Inputs

This actions accepts following inputs:
- `webhook` - The webhook url to send the message to
- `content` - The basic message content
- `username` - Message author name
- `avatar_url` - Author avatar url
- `tts` - Set to a TTS message
- `allowed_mentions` - Comma-separated list of allowed mention types
- `allowed_user_mentions` - Comma-separated list of user id, that are allowed to be mentioned
- `allowed_role_mentions` - Comma-separated list of role id, that are allowed to be mentioned
- `embed` - JSON string of the embed object, or embed array. Unlike the official spec, you can pass strings with newlines

## Examples

Basic message with TTS:
```yaml
- name: 'Send TTS Discord message'
  uses: MineBartekSA/discord-webhook@v1.4
  with:
    webhook: ${{ secrets.WEBHOOK_URL }}
    content: 'Hello Discord, this message is TTS'
    tts: true
```

Embed message:
```yaml
- name: 'Send embedded Discord message'
  uses: MineBartekSA/discord-webhook@v1.4
  with:
    webhook: ${{ secrets.WEBHOOK_URL }}
    embed: '{
        "title": "Github notification",
        "description": "A new discord notification just arrived",
        "color": 65535
      }'
```
> **Note:** Please use the [official Discord docs](https://discord.com/developers/docs/resources/channel#embed-object) to see available fields

Multiple embed message:
```yaml
- name: 'Send a Discord message with multiple embeds'
  uses: MineBartekSA/discord-webhook@v1.4
  with:
    webhook: ${{ secrets.WEBHOOK_URL }}
    embed: '[
        {
          "title": "First embed",
          "description": "One",
          "color": 65535
        },
        {
          "title": "Second embed",
          "description": "Two",
          "color": 16711680
        }
      ]'
```

Embed message with strings including newlines:
```yaml
- name: 'Send embedded Discord message with multiple lines'
  uses: MineBartekSA/discord-webhook@v1.4
  with:
    webhook: ${{ secrets.WEBHOOK_URL }}
    embed: '{
        "title": "Github notification",
        "description": "**Rejoice!**
        
        A new discord notification just arrived!",
        "color": 65535
      }'
```

Basic message with mention control:
```yaml
- name: 'Send Discord message with allowed mentions data only allowing for user mentions and provided role mentions'
  uses: MineBartekSA/discord-webhook@v1.4
  with:
    webhook: ${{ secrets.WEBHOOK_URL }}
    content: 'Hello Discord @everyone'
    allowed_mentions: 'users'
    allowed_role_mentions: '321, 123'
```
> **Note:** Please use [official Discord docs](https://discord.com/developers/docs/resources/channel#allowed-mentions-object) to see correct usage. <br>
> Set `allowed_mentions` to `' '` to send an empty allowed mentions object to disallow any mentions
