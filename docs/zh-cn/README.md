# 🚉 地铁

你在等待一列地铁，那列地铁将带你远去。你知道自己希望被带到哪里，但却不知道将被带到何处。但这并不重要。地铁将带你去哪里怎么会不重要呢？因为我们会在一起。

![Intro](docs/assets/images/intro.png)

## 服务承诺

- 🤹‍♂️ 带着属于你的票据，你可以在任何地方乘坐
- 🔐 [隐私信息全加密](https://guides.rubyonrails.org/active_record_encryption.html)，没人知道你是阿狗还是阿猫
- 🎫 使用独一无二的匿名票据
- 🔍 系统开源开发，保证乘客的安全

## 使用规则

1. 打开服务网站，可按照规则定制化车厢信息，填写完后即可获得匿名票据 `ticket` 和车厢信息 `coach`
1. 乘坐信息可参考唯一坐标 `Permalink`
1. 后续想要重新定制车厢信息或退票，参考指南 `https://subway.com/coaches/{:coach_id}?ticket={:ticket_id}`

## 自建属于你的地铁

### Docker

1. 下载 [docker-compose.yml](https://raw.githubusercontent.com/0x5c3p73r/subway/main/docker-compose.yml) 文件
1. [生成](https://subway-naf0.onrender.com/tools/encrypted_data) 密钥和私密数据
1. 复制并粘贴 `RAILS_MASTER_KEY=[master key]`，`RAILS_ENCRYPTED_DATA=[encrypted data]` 到 `docker-compose.yml`
1. 连接数据库
  1. 使用 `docker-compose.yml` 内置服务可跳过此步
  1. 使用外部 PostgreSQL 数据库需要修改 `DATABASE_URL`。
1. 运行 `docker-compose up -d`

## 隐私政策

本服务承诺隐私数据 100% 加密处理，但也请自建用户保证密钥 `master key` 不被泄露。

本服务部署的地址数据库信息可这这里查阅： https://pgweb-518a.onrender.com/
