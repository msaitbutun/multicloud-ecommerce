# 🌍 Multi-Cloud Global E-Commerce Platform (Terraform, AWS & GCP)

Bu proje, yüksek erişilebilirlik ve sıfır kesinti hedefiyle, bir e-ticaret uygulamasının altyapısını **AWS, GCP ve Cloudflare** kullanarak uçtan uca otomatize edilmiş bir Multi-Cloud mimarisiyle kurmayı amaçlar. Tüm altyapı, maliyet ve güvenlik optimizasyonları gözetilerek **Infrastructure as Code (IaC)** prensibiyle Terraform ile yönetilmiştir.

<img width="1262" height="1013" alt="image" src="https://github.com/user-attachments/assets/f385d3be-da01-45bc-859c-13d08e0e487c" />

## 🛠️ Kullanılan Teknolojiler

| Kategori | Teknoloji | Kullanım Amacı |
| :--- | :--- | :--- |
| **Infrastructure as Code (IaC)** | **Terraform** | AWS ve GCP kaynaklarını tek bir kod tabanından yönetme. |
| **Bulut Sağlayıcıları** | **AWS** (Lambda, RDS, VPC) | Güvenli Backend ve yönetilen ilişkisel veritabanı. |
| **Bulut Sağlayıcıları** | **GCP** (Cloud Run, VPC, Cloud SQL) | Hızlı ve ölçeklenebilir Containerized Frontend hizmeti. |
| **Trafik Yönetimi** | **Cloudflare** | Global Load Balancing, Geo-Routing ve SSL/CDN yönetimi. |
| **Veritabanı** | **AWS RDS (PostgreSQL)** | Persistent (Kalıcı) veri katmanı. VPC içi güvenli erişim. |
| **Konteyner** | **Docker * | Uygulamaların paketlenmesi için. |

