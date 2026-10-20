import 'package:flutter/material.dart';
import 'package:mysample/data/dummy/dummy_transaksi.dart';
import 'package:mysample/widgets/my_app_bar.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  static const _filters = [
    'Semua',
    'Diproses',
    'Dikemas',
    'Dikirim',
    'Selesai',
    'Dibatalkan',
  ];

  String _selected = 'Semua';

  String formatRupiah(int harga) {
    return 'Rp ${harga.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m.group(1)}.')}';
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Selesai':
        return Colors.green;
      case 'Dikirim':
        return Colors.blue;
      case 'Dikemas':
        return Colors.orange;
      case 'Diproses':
        return Colors.purple;
      case 'Dibatalkan':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData getStatusIcon(String status) {
    switch (status) {
      case 'Selesai':
        return Icons.check_circle_rounded;
      case 'Dikirim':
        return Icons.local_shipping_rounded;
      case 'Dikemas':
        return Icons.inventory_2_rounded;
      case 'Diproses':
        return Icons.hourglass_top_rounded;
      case 'Dibatalkan':
        return Icons.cancel_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  String getActionLabel(String status) {
    switch (status) {
      case 'Dikirim':
        return 'Lacak';
      case 'Diproses':
        return 'Tanya Penjual';
      case 'Selesai':
        return 'Nilai Ulasan';
      case 'Dibatalkan':
        return 'Beli Lagi';
      default:
        return 'Detail Pesanan';
    }
  }

  // ---------- Aksi tombol ----------
  void _onActionPressed(BuildContext context, dynamic item) {
    switch (item.status) {
      case 'Dikirim':
        _showTrackingSheet(context, item);
        break;
      case 'Diproses':
        _showAskSellerSheet(context, item);
        break;
      case 'Selesai':
        _showReviewDialog(context, item);
        break;
      case 'Dibatalkan':
        _showSnack(context, '${item.nama} ditambahkan ke keranjang');
        break;
      default:
        _showDetailSheet(context, item);
    }
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  // Lacak
  void _showTrackingSheet(BuildContext context, dynamic item) {
    final cs = Theme.of(context).colorScheme;
    final steps = [
      ('Pesanan dibuat', item.tanggal, true),
      ('Pesanan dikemas', item.tanggal, true),
      ('Diserahkan ke kurir', item.tanggal, true),
      ('Dalam perjalanan', 'Estimasi tiba 1-2 hari', false),
    ];

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lacak Pesanan',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(item.nama, style: TextStyle(color: cs.onSurfaceVariant)),
            const SizedBox(height: 16),
            for (final s in steps)
              ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                leading: Icon(
                  s.$3
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked,
                  color: s.$3 ? cs.primary : cs.outline,
                ),
                title: Text(s.$1),
                subtitle: Text(s.$2),
              ),
          ],
        ),
      ),
    );
  }

  // Tanya Penjual
  Future<void> _showAskSellerSheet(BuildContext context, dynamic item) async {
    final controller = TextEditingController();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          0,
          20,
          MediaQuery.of(sheetContext).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tanya Penjual',
              style: Theme.of(sheetContext).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text('Tentang: ${item.nama}'),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              maxLines: 4,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Tulis pertanyaan Anda...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  if (controller.text.trim().isEmpty) return;
                  Navigator.pop(sheetContext);
                  _showSnack(context, 'Pesan terkirim ke penjual');
                },
                child: const Text('Kirim'),
              ),
            ),
          ],
        ),
      ),
    );

    controller.dispose();
  }

  // Detail Pesanan
  void _showDetailSheet(BuildContext context, dynamic item) {
    final cs = Theme.of(context).colorScheme;

    Widget row(String label, String value) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: cs.onSurfaceVariant)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detail Pesanan',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            row('Produk', item.nama),
            row('Tanggal', item.tanggal),
            row('Status', item.status),
            row('Jumlah', '1 barang'),
            const Divider(),
            row('Total Belanja', formatRupiah(item.harga)),
          ],
        ),
      ),
    );
  }

  // Nilai Ulasan
  void _showReviewDialog(BuildContext context, dynamic item) {
    final controller = TextEditingController();
    int rating = 5;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Nilai Ulasan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(item.nama, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  return IconButton(
                    onPressed: () => setDialogState(() => rating = i + 1),
                    icon: Icon(
                      i < rating
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: Colors.amber,
                      size: 32,
                    ),
                  );
                }),
              ),
              TextField(
                controller: controller,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Ceritakan pengalaman Anda...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _showSnack(
                  this.context,
                  'Terima kasih! Ulasan $rating bintang terkirim',
                );
              },
              child: const Text('Kirim'),
            ),
          ],
        ),
      ),
    ).then((_) => controller.dispose());
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final filtered = _selected == 'Semua'
        ? transactions
        : transactions.where((t) => t.status == _selected).toList();

    return Scaffold(
      backgroundColor: cs.surfaceContainerLowest,
      appBar: MyAppBar(),
      body: Column(
        children: [
          _buildFilterBar(cs),
          Expanded(
            child: filtered.isEmpty
                ? _buildEmptyState(cs)
                : ListView.builder(
                    // ruang bawah agar tidak tertutup navbar melayang
                    padding: const EdgeInsets.only(top: 4, bottom: 110),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) =>
                        _buildCard(context, filtered[index]),
                  ),
          ),
        ],
      ),
    );
  }

  // ---------- Filter chips ----------
  Widget _buildFilterBar(ColorScheme cs) {
    return Container(
      color: cs.surface,
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final f = _filters[i];
          final selected = f == _selected;
          final color = f == 'Semua' ? cs.primary : getStatusColor(f);

          return ChoiceChip(
            label: Text(f),
            selected: selected,
            showCheckmark: false,
            labelStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : cs.onSurfaceVariant,
            ),
            selectedColor: color,
            backgroundColor: cs.surfaceContainerHighest,
            side: BorderSide(color: selected ? color : cs.outlineVariant),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onSelected: (_) => setState(() => _selected = f),
          );
        },
      ),
    );
  }

  // ---------- Empty state ----------
  Widget _buildEmptyState(ColorScheme cs) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.receipt_long_rounded,
            size: 64,
            color: cs.onSurfaceVariant.withAlpha(120),
          ),
          const SizedBox(height: 12),
          Text(
            'Belum ada transaksi',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tidak ada transaksi dengan status "$_selected"',
            style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  // ---------- Card transaksi ----------
  Widget _buildCard(BuildContext context, dynamic item) {
    final cs = Theme.of(context).colorScheme;
    final statusColor = getStatusColor(item.status);
    final cancelled = item.status == 'Dibatalkan';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      color: cs.surface,
      surfaceTintColor: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: cs.outlineVariant),
      ),
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: tanggal & status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 16,
                        color: cs.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item.tanggal,
                        style: TextStyle(
                          fontSize: 12,
                          color: cs.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withAlpha(30),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          getStatusIcon(item.status),
                          size: 13,
                          color: statusColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item.status,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Divider(height: 1, color: cs.outlineVariant),
              const SizedBox(height: 12),

              // Body: gambar & info produk
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Opacity(
                      opacity: cancelled ? 0.5 : 1,
                      child: Image.network(
                        item.foto,
                        width: 68,
                        height: 68,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            width: 68,
                            height: 68,
                            color: cs.surfaceContainerHighest,
                            child: const Center(
                              child: SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 68,
                          height: 68,
                          color: cs.surfaceContainerHighest,
                          child: Icon(
                            Icons.broken_image,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.nama,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: cancelled
                                ? cs.onSurfaceVariant
                                : cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '1 barang',
                          style: TextStyle(
                            fontSize: 12,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Footer: total & tombol aksi
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Belanja',
                        style: TextStyle(
                          fontSize: 11,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        formatRupiah(item.harga),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: cancelled ? cs.onSurfaceVariant : cs.onSurface,
                          decoration: cancelled
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ],
                  ),
                  item.status == 'Dikirim'
                      ? FilledButton.icon(
                          onPressed: () => _onActionPressed(context, item),
                          icon: const Icon(
                            Icons.location_on_outlined,
                            size: 16,
                          ),
                          label: Text(getActionLabel(item.status)),
                          style: FilledButton.styleFrom(
                            backgroundColor: cs.primary,
                            foregroundColor: cs.onPrimary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        )
                      : OutlinedButton(
                          onPressed: () => _onActionPressed(context, item),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: cs.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            side: BorderSide(color: cs.primary),
                          ),
                          child: Text(
                            getActionLabel(item.status),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
