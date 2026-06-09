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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
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
  final List<Tiket> riwayat = [];

  void tambahTiket(Tiket tiket) {
    setState(() {
      riwayat.add(tiket);
      indexHalaman = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final halaman = [
      const BerandaPage(),
      PesanTiketPage(onPesan: tambahTiket),
      RiwayatPage(riwayat: riwayat),
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

// ================= BERANDA =================

class BerandaPage extends StatelessWidget {
  const BerandaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Watermark(
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F6FF),
        appBar: AppBar(
          title: const Text(
            'Beranda',
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
              tween: Tween(begin: 0, end: 1),
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
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.directions_boat,
                      size: 60,
                      color: Colors.white,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Selamat Datang',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Pesan tiket kapal dari Pelabuhan Isda Yunisari menuju Makassar dengan mudah.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            menuCard(
              Icons.location_on,
              'Rute Perjalanan',
              'Pelabuhan Isda Yunisari - Makassar',
            ),
            menuCard(
              Icons.event_seat,
              'Pilihan Kelas',
              'Ekonomi, Bisnis, dan VIP',
            ),
            menuCard(
              Icons.payments,
              'Harga Tiket',
              'Mulai dari Rp 250.000',
            ),
          ],
        ),
      ),
    );
  }

  Widget menuCard(IconData icon, String title, String subtitle) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
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
}

// ================= PESAN TIKET =================

class PesanTiketPage extends StatefulWidget {
  final Function(Tiket) onPesan;

  const PesanTiketPage({
    super.key,
    required this.onPesan,
  });

  @override
  State<PesanTiketPage> createState() => _PesanTiketPageState();
}

class _PesanTiketPageState extends State<PesanTiketPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController jumlahController = TextEditingController();

  String kelas = 'Ekonomi';
  String tanggal = 'Pilih Tanggal';
  int harga = 250000;
  int total = 0;
  bool loading = false;

  void hitungTotal() {
    int jumlah = int.tryParse(jumlahController.text) ?? 0;

    if (kelas == 'Ekonomi') {
      harga = 250000;
    } else if (kelas == 'Bisnis') {
      harga = 400000;
    } else {
      harga = 600000;
    }

    setState(() {
      total = jumlah * harga;
    });
  }

  Future<void> pilihTanggal() async {
    final hasil = await showDatePicker(
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
    if (namaController.text.isEmpty ||
        jumlahController.text.isEmpty ||
        tanggal == 'Pilih Tanggal') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lengkapi semua data terlebih dahulu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    int jumlah = int.tryParse(jumlahController.text) ?? 0;

    if (jumlah <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jumlah tiket harus lebih dari 0'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    hitungTotal();

    setState(() {
      loading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      loading = false;
    });

    final tiket = Tiket(
      nama: namaController.text,
      tanggal: tanggal,
      kelas: kelas,
      jumlah: jumlah,
      total: total,
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
            'Total: Rp ${tiket.total}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                widget.onPesan(tiket);

                namaController.clear();
                jumlahController.clear();

                setState(() {
                  kelas = 'Ekonomi';
                  tanggal = 'Pilih Tanggal';
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
            tween: Tween(begin: 0, end: 1),
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
                        setState(() {
                          kelas = value!;
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
                          detail('Total Harga', 'Rp $total'),
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
                            ? const CircularProgressIndicator(
                                color: Colors.white,
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

  const RiwayatPage({
    super.key,
    required this.riwayat,
  });

  @override
  Widget build(BuildContext context) {
    return Watermark(
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F6FF),
        appBar: AppBar(
          title: const Text(
            'Riwayat',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: riwayat.isEmpty
            ? const Center(
                child: Text(
                  'Belum ada riwayat pemesanan.',
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
                        '${tiket.tanggal} • ${tiket.kelas}\nTotal: Rp ${tiket.total}',
                      ),
                      isThreeLine: true,
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
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
                    item('Total Harga', 'Rp ${tiket.total}'),
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
          children: const [
            Card(
              elevation: 4,
              child: Padding(
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
                      'Aplikasi Tiket Kapal',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('Pelabuhan Isda Yunisari'),
                    SizedBox(height: 8),
                    Text('Rute: Makassar, Sulawesi Selatan'),
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