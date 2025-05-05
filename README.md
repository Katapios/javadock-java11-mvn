# CI/CD с Jenkins для simple-java11-spring-app

Этот проект настраивает автоматическую сборку и запуск Java-приложения с помощью Jenkins в Docker.

---

## 📁 Репозитории

### 🔧 `javadock-java11-mvn` — инфраструктура CI/CD

Репозиторий содержит:
- `docker-compose.yml` — запуск Jenkins, PostgreSQL и других сервисов
- `Dockerfile` — кастомный образ Jenkins с нужными плагинами
- `jenkins.yaml` — конфигурация Jenkins через JCasC
- `plugins.txt` — список установленных Jenkins-плагинов

Здесь находится весь CI/CD-окружение, включая запуск Jenkins и зависимостей.

### 💻 `simple-java11-spring-app` — Java-приложение + Jenkinsfile

Репозиторий содержит:
- Приложение на Spring MVC
- `Jenkinsfile` — pipeline-скрипт для сборки и тестирования

---

## 🚀 Как запустить

### 1. Клонировать оба проекта

```bash
git clone https://github.com/Katapios/javadock-java11-mvn.git
git clone https://github.com/Katapios/simple-java11-spring-app.git
```

---

### 2. Запустить Jenkins-инфраструктуру

```bash
cd javadock-java11-mvn
docker-compose up -d --build
```

- Jenkins: [http://localhost:9080](http://localhost:9080)
- Логин/пароль: `admin` / `admin`

---

### 3. Настроить Webhook в GitHub

Перейди в `Settings > Webhooks` репозитория `simple-java11-spring-app` и добавь:

- Payload URL: `http://<твой_IP>:9080/github-webhook/`
- Content type: `application/json`
- Событие: только `Just the push event`

⚠️ Убедитесь, что Jenkins доступен извне (используй проброс порта или ngrok)

---

### 4. Обязательно: настройка Jenkins job для Webhook

После того как `simple-java11-spring-app` job появилась в Jenkins:

1. Перейди в `Jenkins > simple-java11-spring-app`
2. Нажми **"Configure"**
3. Внизу, в разделе **Build Triggers**, включи:
   ```
   ☑ GitHub hook trigger for GITScm polling
   ```
4. Сохрани — Jenkins теперь реагирует на пуши.

---

## 📄 Jenkinsfile в `simple-java11-spring-app`

```groovy
pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'docker run --rm -v $(pwd):/app -w /app maven:3.8.8-openjdk-11 mvn clean package'
            }
        }
        stage('Test') {
            steps {
                sh 'docker run --rm -v $(pwd):/app -w /app maven:3.8.8-openjdk-11 mvn test'
            }
        }
    }
}
```

---

## 🐞 Возможные ошибки

| Ошибка | Причина и решение |
|--------|--------------------|
| `mvn: not found` | Jenkins запускается без Maven — используйте `docker run maven` |
| `couldn't find remote ref main` | Убедитесь, что в GitHub существует ветка `main` |
| `503 Webhook` | Jenkins не доступен для GitHub — настрой проброс порта или `ngrok` |
| Webhook не триггерит билды | Проверь, что в Jenkins job включено ☑ GitHub hook trigger |

---

## 🔁 Полезные команды

```bash
# Запустить инфраструктуру
docker-compose up -d --build

# Пересобрать Jenkins
docker-compose build jenkins

# Посмотреть логи
docker-compose logs -f jenkins

# Остановить все
docker-compose down
```

---

## 🤝 Взаимодействие между проектами

- Jenkins (из `javadock-java11-mvn`) отслеживает изменения в `simple-java11-spring-app`
- При пуше в GitHub Webhook активирует Jenkins
- Jenkins запускает pipeline из `Jenkinsfile`, используя dockerized Maven

---

## 📌 Автор

CI/CD для Java-приложения с Jenkins и Docker  
by **Katapios**