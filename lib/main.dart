import 'package:flutter/material.dart';

void main() {
  runApp(const TiketPerjalananApp());
}

class TiketPerjalananApp extends StatelessWidget {
  const TiketPerjalananApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IsSea',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const SplashScreen(),
    );
  }
}

class Tiket {
  final String nama;
  final String tanggal;
  final String kelas;
  final int jumlah;
  final int total;

  Tiket({
    required this.nama,
    required this.tanggal,
    required this.kelas,
    required this.jumlah,
    required this.total,
  });
}

// ================= SPLASH SCREEN =================

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animasi;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    animasi = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOutBack,
    );

    controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HalamanUtama(),
        ),
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: ScaleTransition(
          scale: animasi,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.directions_boat,
                size: 90,
                color: Colors.white,
              ),
              SizedBox(height: 16),
              Text(
                'ISDA YUNISARI',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Aplikasi Pemesanan Tiket Kapal',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 28),
              CircularProgressIndicator(
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= HALAMAN UTAMA =================

class HalamanUtama extends StatefulWidget {
  const HalamanUtama({super.key});

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  int indexHalaman = 0;
  String kelasDipilihBeranda = 'Ekonomi';

  final List<Tiket> riwayat = [];

  void pindahKePesanTiket() {
    setState(() {
      indexHalaman = 1;
    });
  }

  void pilihKelasDariBeranda(String kelas) {
    setState(() {
      kelasDipilihBeranda = kelas;
      indexHalaman = 1;
    });
  }

  void tambahTiket(Tiket tiket) {
    setState(() {
      riwayat.add(tiket);
      indexHalaman = 2;
    });
  }

  void hapusTiket(int index) {
    setState(() {
      riwayat.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> halaman = [
      BerandaPage(
        onPesanSekarang: pindahKePesanTiket,
        kelasDipilih: kelasDipilihBeranda,
        onPilihKelas: pilihKelasDariBeranda,
      ),
      PesanTiketPage(
        key: ValueKey(kelasDipilihBeranda),
        kelasAwal: kelasDipilihBeranda,
        onPesan: tambahTiket,
      ),
      RiwayatPage(
        riwayat: riwayat,
        onHapus: hapusTiket,
      ),
      const ProfilPage(),
    ];

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: halaman[indexHalaman],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: indexHalaman,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          setState(() {
            indexHalaman = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number),
            label: 'Tiket',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

// ================= WATERMARK =================

class Watermark extends StatelessWidget {
  final Widget child;

  const Watermark({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: IgnorePointer(
            child: Center(
              child: Opacity(
                opacity: 0.05,
                child: Transform.rotate(
                  angle: -0.5,
                  child: const Text(
                    'ISDA YUNISARI',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ================= Mulai Perjalanmu =================

class BerandaPage extends StatelessWidget {
  final VoidCallback onPesanSekarang;
  final String kelasDipilih;
  final Function(String) onPilihKelas;

  const BerandaPage({
    super.key,
    required this.onPesanSekarang,
    required this.kelasDipilih,
    required this.onPilihKelas,
  });

  @override
  Widget build(BuildContext context) {
    return Watermark(
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F6FF),
        appBar: AppBar(
          title: const Text(
            'Mulai Perjalananmu',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 700),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 40 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Colors.blue,
                      Colors.lightBlueAccent,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.directions_boat,
                      size: 60,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Selamat Datang',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Pesan tiket kapal dari Pelabuhan Isda Yunisari menuju Makassar dengan mudah.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton.icon(
                      onPressed: onPesanSekarang,
                      icon: const Icon(Icons.confirmation_number),
                      label: const Text('Pesan Tiket Sekarang'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            menuCard(
              context,
              Icons.location_on,
              'Rute Perjalanan',
              'Pelabuhan Isda Yunisari - Makassar',
            ),
            menuCard(
              context,
              Icons.event_seat,
              'Pilihan Kelas',
              'Kelas dipilih: $kelasDipilih',
              isPilihKelas: true,
            ),
            menuCard(
              context,
              Icons.payments,
              'Harga Tiket',
              'Ekonomi Rp 250.000, Bisnis Rp 400.000, VIP Rp 600.000',
            ),
            menuCard(
              context,
              Icons.schedule,
              'Jadwal Kapal',
              'Keberangkatan setiap hari pukul 08.00 WITA',
            ),
          ],
        ),
      ),
    );
  }

  Widget menuCard(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle, {
    bool isPilihKelas = false,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: () {
          if (isPilihKelas) {
            tampilkanPilihanKelas(context);
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(title),
                  content: Text(subtitle),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Tutup'),
                    ),
                  ],
                );
              },
            );
          }
        },
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade50,
          child: Icon(icon, color: Colors.blue),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  void tampilkanPilihanKelas(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pilih Kelas Tiket'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              pilihanKelasItem(
                context,
                'Ekonomi',
                'Rp 250.000',
                Icons.event_seat,
              ),
              pilihanKelasItem(
                context,
                'Bisnis',
                'Rp 400.000',
                Icons.chair,
              ),
              pilihanKelasItem(
                context,
                'VIP',
                'Rp 600.000',
                Icons.workspace_premium,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget pilihanKelasItem(
    BuildContext context,
    String kelas,
    String harga,
    IconData icon,
  ) {
    final bool aktif = kelas == kelasDipilih;

    return Card(
      color: aktif ? Colors.blue.shade50 : Colors.white,
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(
          kelas,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(harga),
        trailing: Icon(
          aktif ? Icons.check_circle : Icons.check_circle_outline,
          color: aktif ? Colors.green : Colors.grey,
        ),
        onTap: () {
          Navigator.pop(context);
          onPilihKelas(kelas);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Kelas $kelas berhasil dipilih'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }
}

// ================= PESAN TIKET =================

class PesanTiketPage extends StatefulWidget {
  final Function(Tiket) onPesan;
  final String kelasAwal;

  const PesanTiketPage({
    super.key,
    required this.onPesan,
    required this.kelasAwal,
  });

  @override
  State<PesanTiketPage> createState() => _PesanTiketPageState();
}

class _PesanTiketPageState extends State<PesanTiketPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController jumlahController = TextEditingController();

  late String kelas;
  String tanggal = 'Pilih Tanggal';
  int harga = 250000;
  int total = 0;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    kelas = widget.kelasAwal;
    harga = ambilHargaKelas();
  }

  @override
  void dispose() {
    namaController.dispose();
    jumlahController.dispose();
    super.dispose();
  }

  int ambilHargaKelas() {
    if (kelas == 'Ekonomi') {
      return 250000;
    } else if (kelas == 'Bisnis') {
      return 400000;
    } else {
      return 600000;
    }
  }

  String formatRupiah(int angka) {
    return angka.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  void hitungTotal() {
    final int jumlah = int.tryParse(jumlahController.text) ?? 0;
    final int hargaSekarang = ambilHargaKelas();

    setState(() {
      harga = hargaSekarang;
      total = jumlah * hargaSekarang;
    });
  }

  Future<void> pilihTanggal() async {
    final DateTime? hasil = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (hasil != null) {
      setState(() {
        tanggal = '${hasil.day}-${hasil.month}-${hasil.year}';
      });
    }
  }

  Future<void> pesanTiket() async {
    if (namaController.text.trim().isEmpty ||
        jumlahController.text.trim().isEmpty ||
        tanggal == 'Pilih Tanggal') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lengkapi semua data terlebih dahulu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final int jumlah = int.tryParse(jumlahController.text) ?? 0;

    if (jumlah <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jumlah tiket harus lebih dari 0'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final int hargaSekarang = ambilHargaKelas();
    final int totalSekarang = jumlah * hargaSekarang;

    setState(() {
      harga = hargaSekarang;
      total = totalSekarang;
      loading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() {
      loading = false;
    });

    final Tiket tiket = Tiket(
      nama: namaController.text.trim(),
      tanggal: tanggal,
      kelas: kelas,
      jumlah: jumlah,
      total: totalSekarang,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tiket Berhasil Dipesan'),
          content: Text(
            'Nama: ${tiket.nama}\n'
            'Rute: Pelabuhan Isda Yunisari - Makassar\n'
            'Tanggal: ${tiket.tanggal}\n'
            'Kelas: ${tiket.kelas}\n'
            'Jumlah: ${tiket.jumlah}\n'
            'Total: Rp ${formatRupiah(tiket.total)}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Tutup'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                widget.onPesan(tiket);

                namaController.clear();
                jumlahController.clear();

                setState(() {
                  kelas = widget.kelasAwal;
                  tanggal = 'Pilih Tanggal';
                  harga = ambilHargaKelas();
                  total = 0;
                });
              },
              child: const Text('Lihat Riwayat'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Watermark(
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F6FF),
        appBar: AppBar(
          title: const Text(
            'Pesan Tiket',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 700),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 30 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(
                      Icons.directions_boat,
                      color: Colors.blue,
                      size: 60,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Form Pemesanan Tiket',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: namaController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Penumpang',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: jumlahController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Jumlah Tiket',
                        prefixIcon: Icon(Icons.confirmation_number),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        hitungTotal();
                      },
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      value: kelas,
                      decoration: const InputDecoration(
                        labelText: 'Pilih Kelas',
                        prefixIcon: Icon(Icons.event_seat),
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Ekonomi',
                          child: Text('Ekonomi - Rp 250.000'),
                        ),
                        DropdownMenuItem(
                          value: 'Bisnis',
                          child: Text('Bisnis - Rp 400.000'),
                        ),
                        DropdownMenuItem(
                          value: 'VIP',
                          child: Text('VIP - Rp 600.000'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;

                        setState(() {
                          kelas = value;
                        });

                        hitungTotal();
                      },
                    ),
                    const SizedBox(height: 15),
                    InkWell(
                      onTap: pilihTanggal,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_month),
                            const SizedBox(width: 12),
                            Text(
                              tanggal,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          detail('Berangkat', 'Pelabuhan Isda Yunisari'),
                          detail('Tujuan', 'Makassar, Sulawesi Selatan'),
                          detail('Harga Tiket', 'Rp ${formatRupiah(harga)}'),
                          detail('Total Harga', 'Rp ${formatRupiah(total)}'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: loading ? null : pesanTiket,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: loading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Pesan Tiket Sekarang',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget detail(String judul, String isi) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              judul,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              isi,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= RIWAYAT =================

class RiwayatPage extends StatelessWidget {
  final List<Tiket> riwayat;
  final Function(int) onHapus;

  const RiwayatPage({
    super.key,
    required this.riwayat,
    required this.onHapus,
  });

  String formatRupiah(int angka) {
    return angka.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  @override
  Widget build(BuildContext context) {
    return Watermark(
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F6FF),
        appBar: AppBar(
          title: const Text(
            'Riwayat Pemesanan',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: riwayat.isEmpty
            ? const Center(
                child: Text(
                  'Belum ada riwayat pemesanan tiket.',
                  style: TextStyle(fontSize: 18),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: riwayat.length,
                itemBuilder: (context, index) {
                  final tiket = riwayat[index];

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(
                          Icons.confirmation_number,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        tiket.nama,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${tiket.tanggal} • ${tiket.kelas}\n'
                        '${tiket.jumlah} tiket • Rp ${formatRupiah(tiket.total)}',
                      ),
                      isThreeLine: true,
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Hapus Tiket'),
                                content: const Text(
                                  'Yakin ingin menghapus riwayat tiket ini?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Batal'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      onHapus(index);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Hapus'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailTiketPage(tiket: tiket),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}

// ================= DETAIL TIKET =================

class DetailTiketPage extends StatelessWidget {
  final Tiket tiket;

  const DetailTiketPage({
    super.key,
    required this.tiket,
  });

  String formatRupiah(int angka) {
    return angka.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  @override
  Widget build(BuildContext context) {
    return Watermark(
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F6FF),
        appBar: AppBar(
          title: const Text(
            'Detail Tiket',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [
                    const Icon(
                      Icons.verified,
                      color: Colors.green,
                      size: 70,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Tiket Aktif',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(height: 30),
                    item('Nama Penumpang', tiket.nama),
                    item('Rute', 'Pelabuhan Isda Yunisari - Makassar'),
                    item('Tanggal', tiket.tanggal),
                    item('Kelas', tiket.kelas),
                    item('Jumlah Tiket', '${tiket.jumlah} tiket'),
                    item('Total Harga', 'Rp ${formatRupiah(tiket.total)}'),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Status: Tiket berhasil dipesan.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget item(String judul, String isi) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              judul,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              isi,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= PROFIL =================

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Watermark(
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F6FF),
        appBar: AppBar(
          title: const Text(
            'Profil',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Padding(
                padding: EdgeInsets.all(22),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.directions_boat,
                        color: Colors.white,
                        size: 55,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'IsSea',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('Aplikasi Pemesanan Tiket Kapal'),
                    SizedBox(height: 8),
                    Text('Pelabuhan Isda Yunisari'),
                    SizedBox(height: 8),
                    Text('Rute: Makassar, Sulawesi Selatan'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.info, color: Colors.blue),
                      title: Text('Tentang Aplikasi'),
                      subtitle: Text(
                        'Aplikasi ini digunakan untuk simulasi pemesanan tiket kapal secara digital.',
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.security, color: Colors.blue),
                      title: Text('Status Aplikasi'),
                      subtitle: Text('Beroperasi secara offline pada perangkat.'),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.support_agent, color: Colors.blue),
                      title: Text('Layanan'),
                      subtitle: Text(
                        'Pemesanan tiket, riwayat tiket, detail tiket, dan informasi rute.',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}