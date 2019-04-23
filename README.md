# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## 超级管理员拥有最大权限，和全部菜单。管理员菜单权限数据，直接系统初始化
## 下级角色菜单，由上级角色分配，权限为上级角色的子级

## 开发说明：
### 1. 所有菜单性的controller，继承ApplicationPunditController

## 初始化说明：
### 1. 新增菜单yml文件，初始化对应超级管理员权限：rake init:pundits
