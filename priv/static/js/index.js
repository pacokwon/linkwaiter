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

async function pushRepo(basepath) {
    if (!confirm("Push changes to repository?"))
        return;

    const response = await fetch(`/${basepath}/links/push`, { method: "POST" })
        .then(res => res.text());

    if (response === "ok")
        alert("Successfully Pushed!");
    else
        alert("Something's gone wrong...");
}

async function syncFs(basepath) {
    if (!confirm("Sync links with server filesystem?"))
        return;

    const response = await fetch(`/${basepath}/links/sync`, { method: "POST" })
        .then(res => res.text());

    if (response === "ok")
        window.location.reload();
    else
        alert("Something's gone wrong...");
}
