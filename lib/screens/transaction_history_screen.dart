import 'package:exes/database/database_helper.dart';
import 'package:exes/models/expense.dart';
import 'package:exes/models/transaction_filter.dart';
import 'package:exes/services/settings_controller.dart';
import 'package:exes/widgets/filter_bottom_sheet.dart';
import 'package:exes/widgets/transaction_search_delegate.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionsHistory extends StatefulWidget {
  const TransactionsHistory({
    super.key,
    required this.transactions,
    required this.onDelete,
    required this.onTap,
  });

  final List<ExpenseTransaction> transactions;
  final Future<void> Function(ExpenseTransaction transaction) onDelete;
  final void Function(ExpenseTransaction transaction) onTap;

  @override
  State<TransactionsHistory> createState() => _TransactionsHistoryState();
}

String selectedCategory = "All";

class _TransactionsHistoryState extends State<TransactionsHistory>
    with SingleTickerProviderStateMixin {
  late List<ExpenseTransaction> displayedTransactions;
  TransactionFilter currentFilter = TransactionFilter.empty();
  bool isFiltering = false;
  late final AnimationController sheetController;
  final ScrollController scrollController = ScrollController();

  bool showFAB = false;

  @override
  void initState() {
    super.initState();
    displayedTransactions = List.from(widget.transactions);
    sheetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    scrollController.addListener(() {
      final shouldShow = scrollController.offset > 500;

      if (shouldShow != showFAB) {
        setState(() {
          showFAB = shouldShow;
        });
      }
    });
  }

  @override
  void dispose() {
    sheetController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TransactionsHistory oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.transactions != widget.transactions) {
      displayedTransactions = List.from(widget.transactions);
    }
  }

  Future<void> applyFilter(TransactionFilter filter) async {
    setState(() {
      isFiltering = true;
    });
    final transactions = await DatabaseHelper.instance.getFilteredTransactions(
      filter,
    );

    if (!mounted) return;

    setState(() {
      currentFilter = filter;
      displayedTransactions = transactions;
      isFiltering = false;
    });
  }

  Future<void> openFilterBottomSheet() async {
    final result = await showModalBottomSheet<TransactionFilter>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      transitionAnimationController: sheetController,
      builder: (_) => FilterBottomSheet(onFilter: applyFilter),
    );

    if (result == null) return;
  }

  Future<void> clearFilters() async {
    setState(() {
      currentFilter = TransactionFilter.empty();

      displayedTransactions = List.from(widget.transactions);
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Transactions History"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search_rounded,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () async {
              final result = await showSearch<ExpenseTransaction?>(
                context: context,

                delegate: TransactionSearchDelegate(
                  transactions: displayedTransactions,
                ),
              );

              if (result == null) return;

              widget.onTap(result);
            },
          ),
          if (currentFilter.hasFilters)
            IconButton(
              onPressed: clearFilters,

              icon: Icon(
                Icons.clear_all,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          IconButton(
            icon: Stack(
              children: [
                Icon(
                  Icons.filter_alt_outlined,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),

                if (currentFilter.hasFilters)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        currentFilter.activeFilterCount.toString(),
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () async {
              await openFilterBottomSheet();
            },
          ),
        ],
        centerTitle: true,
      ),
      body: isFiltering
          ? const Center(child: CircularProgressIndicator())
          : SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: displayedTransactions.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              currentFilter.hasFilters
                                  ? Icons.manage_search_rounded
                                  : Icons.receipt_long_rounded,
                              size: 90,
                              color: Theme.of(context).colorScheme.primary,
                            ),

                            const SizedBox(height: 24),

                            Text(
                              currentFilter.hasFilters
                                  ? "No Matching Transactions"
                                  : "No Transactions Yet",
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 12),

                            Text(
                              currentFilter.hasFilters
                                  ? "Try changing your filters or clear them to view all transactions."
                                  : "Start tracking your expenses by adding your first transaction.",
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 28),

                            if (currentFilter.hasFilters)
                              FilledButton.icon(
                                onPressed: clearFilters,
                                icon: const Icon(Icons.filter_alt_off),
                                label: const Text("Clear Filters"),
                              ),
                          ],
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.sort, size: 18),
                            SizedBox(width: 8),
                            Text(currentFilter.sortBy),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${displayedTransactions.length} Transactions",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              if (currentFilter.hasFilters)
                                Text(
                                  "Filtered",
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (currentFilter.hasFilters)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  if (currentFilter.type != "All")
                                    Chip(
                                      label: Text(currentFilter.type),
                                      onDeleted: () async {
                                        await applyFilter(
                                          currentFilter.copyWith(type: "All"),
                                        );
                                      },
                                    ),
                                  if (currentFilter.category != "All")
                                    Chip(
                                      label: Text(currentFilter.category),

                                      onDeleted: () async {
                                        await applyFilter(
                                          currentFilter.copyWith(
                                            category: "All",
                                          ),
                                        );
                                      },
                                    ),
                                  if (currentFilter.startDate != null)
                                    Chip(
                                      label: const Text("Date"),
                                      onDeleted: () async {
                                        await applyFilter(
                                          currentFilter.copyWith(
                                            startDate: null,
                                            endDate: null,
                                          ),
                                        );
                                      },
                                    ),
                                  if (currentFilter.startAmount != 0 ||
                                      currentFilter.endAmount !=
                                          double.infinity)
                                    Chip(
                                      label: const Text("Amount"),

                                      onDeleted: () async {
                                        await applyFilter(
                                          currentFilter.copyWith(
                                            startAmount: 0,
                                            endAmount: double.infinity,
                                          ),
                                        );
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ),
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: () async {
                              if (currentFilter.hasFilters) {
                                await applyFilter(currentFilter);
                              } else {
                                displayedTransactions = List.from(
                                  widget.transactions,
                                );
                                setState(() {});
                              }
                            },
                            child: ListView.separated(
                              separatorBuilder: (context, index) =>
                                  Divider(indent: 16, endIndent: 16),
                              controller: scrollController,
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: displayedTransactions.length,
                              itemBuilder: (context, index) {
                                final transaction =
                                    displayedTransactions[index];
                                return Column(
                                  children: [
                                    Dismissible(
                                      key: ValueKey(transaction.id),
                                      direction: DismissDirection.endToStart,
                                      onDismissed: (direction) async {
                                        await widget.onDelete(transaction);

                                        if (currentFilter.hasFilters) {
                                          await applyFilter(currentFilter);
                                        } else {
                                          displayedTransactions.remove(
                                            transaction,
                                          );
                                          if (mounted) {
                                            setState(() {});
                                          }
                                        }
                                      },
                                      background: Container(
                                        alignment: Alignment.centerRight,
                                        padding: const EdgeInsets.only(
                                          right: 24,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.errorContainer,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.delete_outline,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onErrorContainer,
                                        ),
                                      ),
                                      child: Card(
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 4,
                                        ),
                                        child: AnimatedContainer(
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                          child: ListTile(
                                            onTap: () {
                                              widget.onTap(transaction);
                                            },
                                            leading: CircleAvatar(
                                              backgroundColor: Theme.of(
                                                context,
                                              ).colorScheme.primaryContainer,
                                              child: Text(
                                                transaction.category
                                                    .split(" ")
                                                    .first,
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimaryContainer,
                                                ),
                                              ),
                                            ),
                                            title: Text(
                                              transaction.category
                                                  .split(" ")
                                                  .last,
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleMedium,
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  transaction.note.isEmpty
                                                      ? "No note"
                                                      : transaction.note,
                                                  style: Theme.of(
                                                    context,
                                                  ).textTheme.bodyMedium,
                                                ),
                                                Text(
                                                  DateFormat(
                                                    settings.dateFormat,
                                                  ).format(transaction.date),
                                                  style: Theme.of(
                                                    context,
                                                  ).textTheme.bodySmall,
                                                ),
                                              ],
                                            ),
                                            trailing: Text(
                                              "${transaction.type == "Expense" ? "-" : "+"}"
                                              "${settings.currency}"
                                              "${transaction.amount.toStringAsFixed(2)}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    transaction.type ==
                                                        "Expense"
                                                    ? Colors.red
                                                    : Colors.green,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
      floatingActionButton: AnimatedSlide(
        duration: const Duration(milliseconds: 250),
        offset: showFAB ? Offset.zero : const Offset(0, 2),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 250),
          opacity: showFAB ? 1 : 0,
          child: FloatingActionButton.small(
            heroTag: "historyTop",
            onPressed: () {
              scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 450),
                curve: Curves.easeOutCubic,
              );
            },
            child: const Icon(Icons.keyboard_arrow_up_rounded),
          ),
        ),
      ),
    );
  }
}
