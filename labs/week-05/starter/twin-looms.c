/* twin-looms.c -- Work Order No. 1851-05.
 *
 * The north and south looms both write the output ledger. Each keeps
 * its own count of the entries it has woven, and both add every entry
 * to the ledger's running total.
 *
 * On paper this is simple bookkeeping: whatever the two looms weave
 * between them is what the ledger should hold. At the bench it is not
 * simple at all, and finding out why is this week's work.
 */
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#define DEFAULT_ENTRIES 200000

/* The ledger's running total. Both looms write it. Nothing guards it. */
static long total = 0;

struct loom {
    const char *name;
    long entries;   /* how many this loom is set to weave */
    long woven;     /* how many it actually wove */
};

static void *weave(void *arg)
{
    struct loom *l = arg;
    long i;

    for (i = 0; i < l->entries; i++) {
        /* One entry: add it to the ledger, and tally it as our own. */
        total = total + 1;
        l->woven++;
    }
    return NULL;
}

int main(int argc, char **argv)
{
    struct loom north = { "north", DEFAULT_ENTRIES, 0 };
    struct loom south = { "south", DEFAULT_ENTRIES, 0 };
    pthread_t tn, ts;

    if (argc > 1) {
        long n = strtol(argv[1], NULL, 10);
        if (n <= 0) {
            fprintf(stderr, "twin-looms: entries must be a positive number\n");
            return 2;
        }
        north.entries = n;
        south.entries = n;
    }

    if (pthread_create(&tn, NULL, weave, &north) != 0 ||
        pthread_create(&ts, NULL, weave, &south) != 0) {
        fprintf(stderr, "twin-looms: the looms would not start\n");
        return 1;
    }

    pthread_join(tn, NULL);
    pthread_join(ts, NULL);

    printf("loom north: %ld entries\n", north.woven);
    printf("loom south: %ld entries\n", south.woven);
    printf("ledger total: %ld\n", total);

    return 0;
}
