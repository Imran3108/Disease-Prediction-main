# 🏥 Disease Prediction System

A Django-based web application for intelligent disease prediction using machine learning.

## 🌟 Features

- **ML-Powered Diagnosis**: Predict diseases based on symptoms using trained models
- **Multi-User System**: Separate interfaces for Patients, Doctors, and Admin
- **Consultation System**: Real-time chat between patients and doctors
- **Rating & Reviews**: Patients can rate and review consultations
- **Consultation History**: Track all past consultations
- **PostgreSQL Database**: Robust and scalable data storage

## 🚀 Quick Start

### Prerequisites
- Python 3.8+
- PostgreSQL
- Docker & Docker Compose (for containerized deployment)

### Local Development

1. **Clone the repository**
```bash
git clone <repository-url>
cd Disease-Prediction-main
```

2. **Install dependencies**
```bash
pip install -r requirements.txt
```

3. **Configure database**
   - Create PostgreSQL database: `predico`
   - Update settings in `disease_prediction/settings.py`

4. **Run migrations**
```bash
python manage.py migrate
```

5. **Create superuser**
```bash
python manage.py createsuperuser
```

6. **Run server**
```bash
python manage.py runserver
```

Access the application at: http://localhost:8000

## 🐳 Docker Deployment

### Quick Start with Docker

```bash
chmod +x quick-start.sh
./quick-start.sh
```

### Production Deployment on AWS EC2

See comprehensive deployment guides:
- **[5-Minute Quick Start](DEPLOYMENT-QUICKSTART.md)**
- **[Complete Deployment Guide](README-DEPLOYMENT.md)**
- **[Deployment Summary](DOCKER-DEPLOYMENT-SUMMARY.md)**

### Deployment Commands

```bash
# Basic deployment
docker-compose up -d --build

# Production with Nginx
docker-compose -f docker-compose.nginx.yml up -d --build

# Automated AWS EC2 deployment
./deploy.sh
```

## 📁 Project Structure

```
Disease-Prediction-main/
├── accounts/              # User authentication
├── chats/                 # Real-time messaging
├── main_app/              # Core application logic
│   ├── models.py         # Database models
│   ├── views.py          # Business logic & ML integration
│   └── urls.py           # URL routing
├── disease_prediction/    # Django project settings
│   ├── settings.py       # Configuration
│   └── urls.py           # Main URL patterns
├── templates/            # HTML templates
├── pics/                # User uploaded images
├── trained_model        # ML model file
├── Dockerfile           # Docker image configuration
├── docker-compose.yml   # Docker Compose config
├── requirements.txt     # Python dependencies
└── deploy.sh            # Deployment script
```

## 🔧 Configuration

### Environment Variables

Create `.env` file from `env.example`:

```env
SECRET_KEY=your-secret-key
DEBUG=False
ALLOWED_HOSTS=your-domain.com,localhost

DB_NAME=predico
DB_USER=postgres
DB_PASSWORD=your-password
DB_HOST=localhost
DB_PORT=5432
```

### AWS EC2 Configuration

- **Instance**: t2.medium or larger
- **OS**: Ubuntu 20.04 LTS
- **Ports**: 22 (SSH), 80 (HTTP), 8000 (Django), 5432 (PostgreSQL)

See [setup-aws.sh](setup-aws.sh) for security group configuration.

## 🛠️ Management Commands

### Using Makefile
```bash
make help              # Show all commands
make up                # Start containers
make down              # Stop containers
make logs              # View logs
make shell             # Open shell
make createsuperuser   # Create admin
make backup            # Backup database
```

### Database Management
```bash
# Backup
./backup.sh

# Migrations
python manage.py migrate

# Create superuser
python manage.py createsuperuser
```

## 👥 User Types

### Patients
- Register and create profile
- Check symptoms for disease prediction
- Consult with doctors
- View consultation history
- Rate and review doctors

### Doctors
- Register with credentials and specialization
- View patient consultations
- Chat with patients
- Update consultation status
- View ratings and reviews

### Admin
- Manage all users
- View system statistics
- Monitor feedback
- Manage consultations

## 🤖 Machine Learning Model

The application uses a trained machine learning model (`trained_model`) to predict diseases based on symptom combinations.

**Model Features:**
- 40+ diseases supported
- 100+ symptoms covered
- Confidence scoring
- Specialist recommendations

## 📊 Technologies Used

- **Backend**: Django 2.2.5, Python 3.8
- **Database**: PostgreSQL
- **ML Framework**: scikit-learn, joblib
- **Frontend**: HTML, CSS, JavaScript, Bootstrap
- **Deployment**: Docker, Docker Compose, Nginx
- **Hosting**: AWS EC2

## 🔒 Security Features

- Environment-based configuration
- WhiteNoise for static files
- CSRF protection
- SQL injection prevention
- Secure password handling
- Session management

## 📚 Documentation

- [Deployment Quick Start](DEPLOYMENT-QUICKSTART.md) - 5-minute deployment guide
- [Complete Deployment Guide](README-DEPLOYMENT.md) - Detailed instructions
- [Deployment Summary](DOCKER-DEPLOYMENT-SUMMARY.md) - Architecture and commands

## 🐛 Troubleshooting

### Common Issues

**Static files not loading**
```bash
python manage.py collectstatic --noinput
```

**Database connection error**
- Check PostgreSQL is running
- Verify database credentials in settings

**Docker build fails**
```bash
docker-compose down -v
docker-compose up -d --build
```

See [Troubleshooting Guide](DOCKER-DEPLOYMENT-SUMMARY.md#troubleshooting-guide) for more details.

## 🤝 Contributing

1. Fork the repository
2. Create feature branch
3. Commit changes
4. Push to branch
5. Open Pull Request

## 📝 License

This project is licensed under the MIT License.

## 👤 Author

Disease Prediction System

## 🙏 Acknowledgments

- Django community
- scikit-learn team
- PostgreSQL developers
- AWS EC2

## 📞 Support

For deployment assistance, see:
- [Deployment Quick Start](DEPLOYMENT-QUICKSTART.md)
- [Docker Deployment Summary](DOCKER-DEPLOYMENT-SUMMARY.md)

## 🚀 Deployment Status

✅ Docker configuration  
✅ AWS EC2 setup scripts  
✅ PostgreSQL integration  
✅ Production-ready settings  
✅ Automated deployment  
✅ Nginx configuration  
✅ Health checks  
✅ Backup scripts  

---

**Ready to Deploy?** Start with [DEPLOYMENT-QUICKSTART.md](DEPLOYMENT-QUICKSTART.md) 🚀

