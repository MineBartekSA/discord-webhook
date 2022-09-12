# Composite Discord Webhooks

Github Actions for sending messages through Discord's Webhooks.

Unlike other actions, this action is based on composite actions, meaning it doesn't need to build and works on every runner.

Using this action you can send simple or complex messages.
You can even upload files to Discord.

## Usage

```yaml
- name: Send a basic message
  uses: MineBartekSA/discord-webhook@v2
  with:
    webhook: ${{ secrets.WEBHOOK_URL }}
    content: Hello Discord
```
> **Note**
> There is no runner restriction. Any will do.

For debugging purposes, it is strongly suggested to add `/v10/` path segment after the `/api/` segment in your webhook url.

## Inputs

This actions have following inputs:
- [`webhook`](#1-webhook-and-content)
- [`content`](#1-webhook-and-content)
- [`username`](#2-username-and-avatar-url)
- [`avatar_url`](#2-username-and-avatar-url)
- [`tts`](#3-tts)
- [`allowed_mentions`](#4-allowed-mentions)
- [`allowed_user_mentions`](#4-allowed-mentions)
- [`allowed_role_mentions`](#4-allowed-mentions)
- [`embed`](#5-embed)
- [`component`](#6-component)
- [`attachment`](#7-attachment)

### 1. Webhook and Content

The most basic inputs, the `webhook` and `content` inputs.
They are essential for this actions to function, though `content` is optional if you already have the `embed` or `attachment`.

The webhook input is the only **required** input in the whole action, without it you wouldn't be able to send messages.

It is possible to provide multiple webhooks.
By separating the urls by a single space, you can send the message to multiple webhooks.
Be aware that error reporting was not designed with this in mind.

```yaml
- name: Send a basic message
  uses: MineBartekSA/discord-webhook@v2
  with:
    webhook: ${{ secrets.WEBHOOK_URL }}
    content: |
      Basic message content
      supports multi line text.
      Be sure to use it well!
```
> **Note**
> You do not need to use secrets to insert your webhook, but it is a good practice.

### 2. Username and Avatar URL

Using this input, you can set the author text of the message.
This will overwrite the default webhook name.

```yaml
- name: Send a basic message with username and avatar changed
  uses: MineBartekSA/discord-webhook@v2
  with:
    webhook: ${{ secrets.WEBHOOK_URL }}
    content: Look! A different username and avatar!
    username: Emanresu
    avatar_url: https://avatars.githubusercontent.com/u/19757593
```

### 3. TTS

You can set the message to be TTS.
To be honest, I have never seen a TTS message in the wild, but here is the option if you want it.

```yaml
- name: Send a basic TTS message
  uses: MineBartekSA/discord-webhook@v2
  with:
    webhook: ${{ secrets.WEBHOOK_URL }}
    content: Hello Discord
    tts: true
```

### 4. Allowed mentions

This section will cover `allowed_mentions`, `allowed_user_mentions`, and `allowed_role_mentions` inputs.

Using these inputs, you can control the mentions created by the message.
To see more, please visit the [official Discord docs](https://discord.com/developers/docs/resources/channel#allowed-mentions-object) on this subject.

All of these inputs accept comma-separated text.

```yaml
- name: Send a basic message with mention control
  uses: MineBartekSA/discord-webhook@v2
  with:
    webhook: ${{ secrets.WEBHOOK_URL }}
    content: Hello Discord
    allowed_mentions: ' ' # Use this to suppress all mentions, except provided in the following inputs
    allowed_user_mentions: 123, 321
    allowed_role_mentions: 456, 654
```

### 5. Embed

Using this input, you can send embedded messages.

This input accepts YAML and JSON strings of the embed object.
To see available fields, see the [official Discord docs](https://discord.com/developers/docs/resources/channel#embed-object) on this subject.

An example of embed using YAML
```yaml
- name: Send a basic embedded message using YAML
  uses: MineBartekSA/discord-webhook@v2
  with:
    webhook: ${{ secrets.WEBHOOK_URL }}
    embed: |
      title: Embed Title
      description: |
        Multiline embed
        description here
      color: 16711680
```

An example of embed using JSON
```yaml
- name: Send a basic embedded message using JSON
  uses: MineBartekSA/discord-webhook@v2
  with:
    webhook: ${{ secrets.WEBHOOK_URL }}
    embed: |
      {
        "title": "Embed Title",
        "description": "Multiline embed
        description here
        (this is against the official JSON spec, but for convenience this action support this)",
        "color": 16711680
      }
```

An example of multiple embeds using YAML
```yaml
- name: Send a message with multiple embeds
  uses: MineBartekSA/discord-webhook@v2
  with:
    webhook: ${{ secrets.WEBHOOK_URL }}
    embed: |
      - title: First Embed Title
        description: |
          Multiline embed
          description here
        color: 16711680
      - title: Second Embed Title
        description: The second one
        color: 65535
```

An example of a complex embed using YAML
```yaml
- name: Send a complex embedded message
  uses: MineBartekSA/discord-webhook@v2
  with:
    webhook: ${{ secrets.WEBHOOK_URL }}
    embed: |
      title: Complex embed
      color: 65535
      author:
        name: MineBartekSA
        url: https://github.com/MineBartekSA
        icon_url: https://avatars.githubusercontent.com/u/19757593
      description: |
        This is an example of a multi line
        text in an embed
      image:
        url: https://http.cat/100
      fields:
        - name: First field
          value: The value of the First field
        - name: Second field
          value: Value of the Second one
      footer:
        text: Footer text
```

### 6. Component

Using this input, you can send messages with components.

> **Warning**
> To use components in webhooks, the webhook must be created by an application

This input accepts YAML and JSON strings of the component object.
To see available fields, see the [official Discord docs](https://discord.com/developers/docs/interactions/message-components#component-object) on this subject.

An example of component usage using YAML
```yaml
- name: Send a message with a component using YAML
  uses: MineBartekSA/discord-webhook@v2
  with:
    webhook: ${{ secrets.APPLICATION_WEBHOOK }}
    content: Some text
    component: |
      type: 2
      style: 5
      label: Link Button
      url: https://google.com/
```

An example of component usage using JSON
```yaml
- name: Send a message with a component using JSON
  uses: MineBartekSA/discord-webhook@v2
  with:
    webhook: ${{ secrets.APPLICATION_WEBHOOK }}
    content: Some text
    component: |
      {
        "type": 2,
        "style": 5,
        "label": "Link Button",
        "url": "https://google.com/"
      }
```

An example of component usage with multiple components using YAML
```yaml
- name: Send a message with multiple component
  uses: MineBartekSA/discord-webhook@v2
  with:
    webhook: ${{ secrets.APPLICATION_WEBHOOK }}
    content: Some text
    component: |
      - type: 2
        style: 5
        label: Link Button
        url: https://google.com/
      - type: 2
        style: 5
        label: Second Link Button
        url: https://github.com/
```

An example of component usage with multiple rows using YAML
```yaml
- name: Send a message with a component in multiple rows
  uses: MineBartekSA/discord-webhook@v2
  with:
    webhook: ${{ secrets.APPLICATION_WEBHOOK }}
    content: Some text
    component: |
      - type: 1
        components:
          - type: 2
            style: 5
            label: First Row Link Button
            url: https://google.com/
      - type: 1
        components:
          - type: 2
            style: 5
            label: Second Row Link Button
            url: https://github.com/
```

### 7. Attachment

Using this input, you can upload files.

This input accepts YAML and JSON strings of the attachment object with an additional `file` field.
To see available fields, see the [official Discord docs](https://discord.com/developers/docs/resources/channel#attachment-object) on this subject.

The additional `file` field is always required and is for setting the path to the file you want to upload.

An example of a simple file upload using YAML
```yaml
- name: Upload file using YAML
  uses: MineBartekSA/discord-webhook@v2
  with:
    webhook: ${{ secrets.WEBHOOK_URL }}
    attachment: |
      file: path/to/file
```

An example of a simple file upload using JSON
```yaml
- name: Upload file using JSON
  uses: MineBartekSA/discord-webhook@v2
  with:
    webhook: ${{ secrets.WEBHOOK_URL }}
    attachment: |
      {
        "file": "path/to/file"
      }
```

An example of a file upload with name change using YAML
```yaml
- name: Upload file and change its name
  uses: MineBartekSA/discord-webhook@v2
  with:
    webhook: ${{ secrets.WEBHOOK_URL }}
    attachment: |
      file: path/to/file
      filename: file-name-chnaged-to-this.txt
```

An example of uploading multiple files using YAML
```yaml
- name: Upload multiple files
  uses: MineBartekSA/discord-webhook@v2
  with:
    webhook: ${{ secrets.WEBHOOK_URL }}
    attachment: |
      - file: path/to/first/file
        filename: first-file.txt
      - file: path/to/second/file
        filename: second-file.txt
        description: There is a description field in Discord's Attachment model
```

## Examples

```yaml
- name: Send a complex message
  uses: MineBartekSA/discord-webhook@v2
  with:
    webhook: ${{ secrets.WEBHOOK_URL }}
    content: Complex message
    embed: |
      - title: First embed
        description: 1
        footer:
          text: 1 embed footer
      - title: Second embed
        image:
          url: attachment://test-file.jpg
        footer:
          text: An example of how to use attachments
    attachment: |
      file: path/to/file
      filename: test-file.jpg
```
