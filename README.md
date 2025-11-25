# 🌍 Multi-Cloud Global E-Commerce Platform (Terraform, AWS & GCP)

Bu proje, yüksek erişilebilirlik ve sıfır kesinti hedefiyle, bir e-ticaret uygulamasının altyapısını **AWS, GCP ve Cloudflare** kullanarak uçtan uca otomatize edilmiş bir Multi-Cloud mimarisiyle kurmayı amaçlar. Tüm altyapı, maliyet ve güvenlik optimizasyonları gözetilerek **Infrastructure as Code (IaC)** prensibiyle Terraform ile yönetilmiştir.
Projenin çalışma prensibi için medium yazısını da inceleyebilirsiniz.
https://medium.com/@btn.sait/dayan%C4%B1kl%C4%B1-bir-%C3%A7oklu-bulut-e-ticaret-platformu-kurulumu-aws-gcp-ve-cloudflare%C4%B1n-g%C3%BC%C3%A7lerini-6284e241ee0d?postPublishedType=repub

<img width="1262" height="1013" alt="image" src="https://github.com/user-attachments/assets/f385d3be-da01-45bc-859c-13d08e0e487c" />

## 🛠️ Kullanılan Teknolojiler

| Kategori | Teknoloji | Kullanım Amacı |
| :--- | :--- | :--- |
| **Infrastructure as Code (IaC)** | **Terraform** | AWS ve GCP kaynaklarını tek bir kod tabanından yönetme. |
| **Bulut Sağlayıcıları** | **AWS** (Lambda, RDS, VPC) | Güvenli Backend ve yönetilen ilişkisel veritabanı. |
| **Bulut Sağlayıcıları** | **GCP** (Cloud Run, VPC, Cloud SQL) | Hızlı ve ölçeklenebilir Containerized Frontend hizmeti. |
| **Trafik Yönetimi** | **Cloudflare** | Global Load Balancing, Geo-Routing ve SSL/CDN yönetimi. |
| **Veritabanı** | **AWS RDS (PostgreSQL)** | Persistent (Kalıcı) veri katmanı. VPC içi güvenli erişim. |
| **Konteyner** | **Docker** | Uygulamaların paketlenmesi için. |

## ⚙️ Kurulum ve Çalıştırma (Deployment Steps)

1.  **Kimlik Doğrulama:** AWS ve GCP API Key/Service Account'lar için ilgili ortam değişkenlerini ayarlayın.
2.  **Terraform Init:** `terraform init -backend-config="bucket=..."` ile Remote State'i başlatın.
3.  **Plan & Apply:** Kurulumu gözden geçirin ve uygulayın.
    ```bash
    terraform plan
    terraform apply
    ```
    *(NOT: Tüm kaynaklar, olası maliyet artışını önlemek için en düşük konfigürasyonda kurulmuştur.)*
4.  **Uygulama Dağıtımı:** Backend (Lambda) ve Frontend (Cloud Run) kodlarını ilgili bulut servislerine deploy edin, frontend klasöründe bulunan dockerfile ile imajı gcp'ye atın.
    *(NOT: Dockeri gcloud için yetkilendirmelisiniz.)*
     ```bash
        gcloud auth configure-docker
    ```
6.  **Cloudflare Entegrasyonu:** Terraform çıktısındaki AWS/GCP Load Balancer IP'lerini Cloudflare DNS'ine girin.


## 🗑️ Kaynakları Kaldırma

Çalışmayı bitirdiğinizde veya maliyetleri önlemek için tüm kaynakları tek komutla kapatın:

```bash
terraform destroy
```
<img width="2514" height="1691" alt="image" src="https://github.com/user-attachments/assets/5617558e-338c-444a-a8e3-037a49041d7f" />






