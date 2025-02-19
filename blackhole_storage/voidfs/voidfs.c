// blackhole_storage/voidfs/voidfs.c
#include <linux/fs.h>
#include <linux/module.h>

#define VOIDFS_MAGIC 0xDEADBEEF

static struct file_system_type voidfs_type = {
    .owner = THIS_MODULE,
    .name = "voidfs",
    .mount = voidfs_mount,
    .kill_sb = kill_litter_super,
};

static struct dentry *voidfs_mount(struct file_system_type *type,
    int flags, const char *dev, void *data)
{
    return mount_nodev(type, flags, data, voidfs_fill_super);
}

static int voidfs_fill_super(struct super_block *sb, void *data, int silent)
{
    sb->s_magic = VOIDFS_MAGIC;
    sb->s_op = &voidfs_super_ops;
    return 0;
}

static void voidfs_evaporate(struct inode *inode)
{
    // Redirect all writes to /dev/null
    inode->i_op = &voidfs_inode_ops;
    inode->i_fop = &voidfs_file_ops;
}

static const struct super_operations voidfs_super_ops = {
    .evict_inode = voidfs_evaporate,
};

module_init(voidfs_init);
module_exit(voidfs_exit);
