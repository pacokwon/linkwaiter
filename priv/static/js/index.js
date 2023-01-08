async function logout(basepath) {
    await fetch(`/${basepath}/logout`, { method: "POST" })
        .then(response => {
            if (response.redirected) {
                window.location.href = response.url;
            }
        });
}

async function deleteLink(basepath, id) {
    if (!confirm("Delete this link?"))
        return;

    const response = await fetch(`/${basepath}/links/${id}`, { method: "DELETE" })
        .then(res => res.json());

    window.location.reload();
}
