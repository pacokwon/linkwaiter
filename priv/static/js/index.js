async function deleteLink(id) {
    if (!confirm("Delete this link?"))
        return;

    const response = await fetch(`/links/${id}`, { method: "DELETE" })
        .then(res => res.json());

    window.location.reload();
}
